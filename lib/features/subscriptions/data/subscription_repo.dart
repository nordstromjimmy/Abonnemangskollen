import 'package:isar_community/isar.dart';
import '../../../shared/isar_service.dart';
import 'subscription.dart';

class SubscriptionRepo {
  Future<List<Subscription>> getAll() async {
    final isar = await IsarService.db();
    return await isar.subscriptions.where().findAll();
  }

  Stream<List<Subscription>> watchAll() async* {
    final isar = await IsarService.db();
    yield* isar.subscriptions.where().watch(fireImmediately: true);
  }

  Future<int> add(Subscription sub) async {
    final isar = await IsarService.db();
    return await isar.writeTxn(() async {
      final id = await isar.subscriptions.put(sub);
      return id; // Isar Id (int)
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
