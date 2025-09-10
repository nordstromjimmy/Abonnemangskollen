import 'package:flutter/foundation.dart';
import '../../subscriptions/data/subscription.dart';

@immutable
class EditSubState {
  final int id;
  final String name;
  final String? category;
  final String currency;
  final double? price;
  final BillingPeriod period;
  final int? customInterval;
  final DateTime nextRenewal;
  final int notifyDaysBefore;
  final String? notes;
  final bool isSaving;
  final String? error;

  const EditSubState({
    required this.id,
    required this.name,
    required this.category,
    required this.currency,
    required this.price,
    required this.period,
    required this.customInterval,
    required this.nextRenewal,
    required this.notifyDaysBefore,
    this.notes,
    this.isSaving = false,
    this.error,
  });

  factory EditSubState.fromSub(Subscription s) => EditSubState(
    id: s.id,
    name: s.name,
    category: s.category,
    currency: s.currency,
    price: s.price,
    period: s.period,
    customInterval: s.customInterval,
    nextRenewal: s.nextRenewal,
    notifyDaysBefore: s.notifyDaysBefore,
    notes: s.notes,
  );

  bool get valid =>
      name.trim().isNotEmpty &&
      (price ?? 0) > 0 &&
      (period != BillingPeriod.custom || (customInterval ?? 0) > 0);

  EditSubState copyWith({
    String? name,
    String? category,
    String? currency,
    double? price,
    BillingPeriod? period,
    int? customInterval,
    DateTime? nextRenewal,
    int? notifyDaysBefore,
    String? notes,
    bool? isSaving,
    String? error,
  }) => EditSubState(
    id: id,
    name: name ?? this.name,
    category: category ?? this.category,
    currency: currency ?? this.currency,
    price: price ?? this.price,
    period: period ?? this.period,
    customInterval: customInterval ?? this.customInterval,
    nextRenewal: nextRenewal ?? this.nextRenewal,
    notifyDaysBefore: notifyDaysBefore ?? this.notifyDaysBefore,
    notes: notes ?? this.notes,
    isSaving: isSaving ?? this.isSaving,
    error: error,
  );
}
