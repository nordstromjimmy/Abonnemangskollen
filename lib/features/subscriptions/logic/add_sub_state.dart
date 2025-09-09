import 'package:flutter/foundation.dart';
import '../../subscriptions/data/subscription.dart';

@immutable
class AddSubState {
  final String name;
  final String? category;
  final String currency;
  final double? price;
  final BillingPeriod period;
  final int? customInterval;
  final DateTime nextRenewal;
  final int notifyDaysBefore;
  final bool isSaving;
  final String? error;

  AddSubState({
    this.name = '',
    this.category,
    this.currency = 'SEK',
    this.price,
    this.period = BillingPeriod.monthly,
    this.customInterval,
    DateTime? nextRenewal,
    this.notifyDaysBefore = 14,
    this.isSaving = false,
    this.error,
  }) : nextRenewal = nextRenewal ?? _defaultNext();

  bool get valid =>
      name.trim().isNotEmpty &&
      (price ?? 0) > 0 &&
      (period != BillingPeriod.custom || (customInterval ?? 0) > 0);

  AddSubState copyWith({
    String? name,
    String? category,
    String? currency,
    double? price,
    BillingPeriod? period,
    int? customInterval,
    DateTime? nextRenewal,
    int? notifyDaysBefore,
    bool? isSaving,
    String? error,
  }) => AddSubState(
    name: name ?? this.name,
    category: category ?? this.category,
    currency: currency ?? this.currency,
    price: price ?? this.price,
    period: period ?? this.period,
    customInterval: customInterval ?? this.customInterval,
    nextRenewal: nextRenewal ?? this.nextRenewal,
    notifyDaysBefore: notifyDaysBefore ?? this.notifyDaysBefore,
    isSaving: isSaving ?? this.isSaving,
    error: error,
  );

  static DateTime _defaultNext() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).add(const Duration(days: 30));
  }
}
