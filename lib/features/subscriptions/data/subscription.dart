import 'package:isar_community/isar.dart';

part 'subscription.g.dart';

enum BillingPeriod { monthly, quarterly, yearly, custom }

@collection
class Subscription {
  Id id = Isar.autoIncrement; // Auto-incrementing ID

  late String name;
  String? category; // e.g. "Streaming"
  double price = 0;
  String currency = "SEK";

  @enumerated
  BillingPeriod period = BillingPeriod.monthly;

  int? customInterval; // e.g. every 2 months
  late DateTime nextRenewal;
  int notifyDaysBefore = 14;
  bool isActive = true;
  String? notes;
}
