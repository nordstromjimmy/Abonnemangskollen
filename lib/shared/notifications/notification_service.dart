import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/subscriptions/data/subscription.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Timezones
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Stockholm'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(initSettings);

    // Request runtime permission on Android 13+ and iOS
    if (Platform.isAndroid) {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidImpl?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> scheduleRenewalReminder({
    required Subscription sub,
    required int notificationId,
  }) async {
    final lead = Duration(days: sub.notifyDaysBefore);
    final target = DateTime(
      sub.nextRenewal.year,
      sub.nextRenewal.month,
      sub.nextRenewal.day,
      9,
      0,
    );
    DateTime fire = target.subtract(lead);

    final now = DateTime.now();
    if (fire.isBefore(now)) {
      fire = now.add(const Duration(minutes: 1));
    }

    final tzTime = tz.TZDateTime.from(fire, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'renewals',
      'Förnyelser',
      channelDescription: 'Påminnelser inför abonnemangsförnyelser',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      notificationId,
      'Påminnelse: ${sub.name}',
      'Förnyas ${_dateLabel(sub.nextRenewal)}',
      tzTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }

  Future<void> cancelForSubscription(int notificationId) async {
    await _plugin.cancel(notificationId);
  }

  static String _dateLabel(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }
}
