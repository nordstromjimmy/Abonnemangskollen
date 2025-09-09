import 'package:isar_community/isar.dart';
import '../../../shared/isar_service.dart';
import 'subscription.dart';

class SubscriptionRepo {
  Future<List<Subscription>> getAll() async {
    final isar = await IsarService.db();
    return await isar.subscriptions.where().findAll();
  }

  /// Reactive stream of all subscriptions. Fires immediately, then on any change.
  Stream<List<Subscription>> watchAll() async* {
    final isar = await IsarService.db();
    // You can filter here if you only want active ones:
    // final query = isar.subscriptions.filter().isActiveEqualTo(true);
    final query = isar.subscriptions.where();
    yield* query.watch(fireImmediately: true);
  }

  Future<void> add(Subscription sub) async {
    final isar = await IsarService.db();
    await isar.writeTxn(() async {
      await isar.subscriptions.put(sub);
    });
  }

  Future<void> upsert(Subscription sub) async {
    final isar = await IsarService.db();
    await isar.writeTxn(() => isar.subscriptions.put(sub));
  }

  Future<void> delete(int id) async {
    final isar = await IsarService.db();
    await isar.writeTxn(() async {
      await isar.subscriptions.delete(id);
    });
  }
}
