import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers.dart';
import '../../subscriptions/data/subscription.dart';
import '../../subscriptions/data/subscription_repo.dart';
import '../../../shared/notifications/notification_service.dart';
import 'edit_sub_state.dart';

final editSubProvider = StateNotifierProvider.autoDispose
    .family<EditSubNotifier, EditSubState, Subscription>((ref, sub) {
      final repo = ref.read(subscriptionRepoProvider);
      return EditSubNotifier(repo, sub);
    });

class EditSubNotifier extends StateNotifier<EditSubState> {
  final SubscriptionRepo repo;
  EditSubNotifier(this.repo, Subscription initial)
    : super(EditSubState.fromSub(initial));

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
  void setNotes(String v) => state = state.copyWith(notes: v);

  Future<bool> save() async {
    if (!state.valid) {
      state = state.copyWith(error: 'Fyll i alla obligatoriska fält.');
      return false;
    }
    state = state.copyWith(isSaving: true, error: null);

    final sub = Subscription()
      ..id = state.id
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
      ..notes = state.notes?.trim()
      ..isActive = true;

    try {
      await repo.upsert(sub);
      // reschedule notification
      unawaited(NotificationService.instance.cancelForSubscription(state.id));
      unawaited(
        NotificationService.instance
            .scheduleRenewalReminder(sub: sub, notificationId: state.id)
            .catchError((e, st) => debugPrint('Reschedule failed: $e')),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Kunde inte spara: $e');
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  Future<bool> delete() async {
    try {
      await NotificationService.instance.cancelForSubscription(state.id);
      await repo.delete(state.id);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Kunde inte radera: $e');
      return false;
    }
  }
}
