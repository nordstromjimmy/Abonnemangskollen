import '../../subscriptions/data/subscription.dart';
import '../../subscriptions/data/subscription_repo.dart';
import '../models/home_data.dart';

class HomeController {
  final SubscriptionRepo repo;
  HomeController({SubscriptionRepo? repo}) : repo = repo ?? SubscriptionRepo();

  Future<HomeData> load() async {
    final items = await repo.getAll();
    return _compute(items);
  }

  /// Stream-based: react to any Isar changes
  Stream<HomeData> watch() {
    return repo.watchAll().map(_compute);
  }

  HomeData _compute(List<Subscription> items) {
    final now = DateTime.now();
    final active = items.where((s) => s.isActive).toList();

    final monthlyTotal = active
        .map(_monthlyCost)
        .fold<double>(0, (a, b) => a + b);

    final startOfToday = DateTime(now.year, now.month, now.day);
    final upcoming = active.where((s) {
      final diff = s.nextRenewal.difference(startOfToday).inDays;
      return diff >= 0 && diff <= 30;
    }).toList()..sort((a, b) => a.nextRenewal.compareTo(b.nextRenewal));

    final recent = List<Subscription>.from(items)
      ..sort((a, b) => b.id.compareTo(a.id));

    return HomeData(
      items: items,
      monthlyTotal: monthlyTotal,
      upcoming: upcoming,
      recent: recent.take(5).toList(),
    );
  }

  double _monthlyCost(Subscription s) {
    switch (s.period) {
      case BillingPeriod.monthly:
        return s.price;
      case BillingPeriod.quarterly:
        return s.price / 3.0;
      case BillingPeriod.yearly:
        return s.price / 12.0;
      case BillingPeriod.custom:
        final interval = (s.customInterval ?? 1).clamp(1, 120);
        return s.price / interval;
    }
  }
}
