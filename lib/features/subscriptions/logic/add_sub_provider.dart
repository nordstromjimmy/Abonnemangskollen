import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../subscriptions/data/subscription.dart';
import '../../subscriptions/data/subscription_repo.dart';
import '../../../shared/notifications/notification_service.dart';
import 'add_sub_state.dart';

final addSubProvider = StateNotifierProvider<AddSubNotifier, AddSubState>((
  ref,
) {
  final repo = ref.read(subscriptionRepoProvider);
  return AddSubNotifier(repo);
});

final subscriptionRepoProvider = Provider<SubscriptionRepo>(
  (ref) => SubscriptionRepo(),
);

class AddSubNotifier extends StateNotifier<AddSubState> {
  final SubscriptionRepo repo;
  AddSubNotifier(this.repo) : super(AddSubState());

  void setName(String v) => state = state.copyWith(name: v);
  void setCategory(String? v) => state = state.copyWith(category: v);
  void setCurrency(String v) => state = state.copyWith(currency: v);
  void setPrice(String v) =>
      state = state.copyWith(price: double.tryParse(v.replaceAll(',', '.')));
  void setPeriod(BillingPeriod v) => state = state.copyWith(period: v);
  void setCustomInterval(String v) =>
      state = state.copyWith(customInterval: int.tryParse(v));
  void setNextRenewal(DateTime d) => state = state.copyWith(nextRenewal: d);
  void setNotifyDays(int v) => state = state.copyWith(notifyDaysBefore: v);

  Future<bool> save() async {
    if (!state.valid) {
      state = state.copyWith(error: 'Fyll i alla obligatoriska fält.');
      return false;
    }
    state = state.copyWith(isSaving: true, error: null);

    final sub = Subscription()
      ..name = state.name.trim()
      ..category = state.category?.trim()
      ..price = state.price ?? 0
      ..currency = state.currency
      ..period = state.period
      ..customInterval = state.period == BillingPeriod.custom
          ? (state.customInterval ?? 1)
          : null
      ..nextRenewal = state.nextRenewal
      ..notifyDaysBefore = state.notifyDaysBefore
      ..isActive = true;

    try {
      final id = await repo.add(sub); // returns Id
      unawaited(
        NotificationService.instance
            .scheduleRenewalReminder(sub: sub, notificationId: id)
            .catchError(
              (e, st) => debugPrint('Notification schedule failed: $e'),
            ),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Kunde inte spara: $e');
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
