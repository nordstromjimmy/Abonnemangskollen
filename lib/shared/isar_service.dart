import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../features/subscriptions/data/subscription.dart';

class IsarService {
  static Isar? _isar;

  static Future<Isar> db() async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [SubscriptionSchema], // register your schemas here
      directory: dir.path,
    );

    return _isar!;
  }
}
