import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/subscriptions/data/subscription_repo.dart';
import '../features/home/logic/home_controller.dart';
import '../features/home/models/home_data.dart';

final subscriptionRepoProvider = Provider<SubscriptionRepo>(
  (ref) => SubscriptionRepo(),
);

/// Reactive home data computed from Isar changes
final homeDataProvider = StreamProvider<HomeData>((ref) {
  final repo = ref.watch(subscriptionRepoProvider);
  final controller = HomeController(repo: repo);
  return controller.watch();
});
