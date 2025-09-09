import '../../subscriptions/data/subscription.dart';

class HomeData {
  final List<Subscription> items;
  final double monthlyTotal;
  final List<Subscription> upcoming;
  final List<Subscription> recent;

  HomeData({
    required this.items,
    required this.monthlyTotal,
    required this.upcoming,
    required this.recent,
  });
}
