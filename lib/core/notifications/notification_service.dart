import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static const _channelId = 'daily_name';
  static const _channelName = 'Nom du jour';
  static const _channelDesc = 'Rituel quotidien Sirah Hub';
  static const _defaultTimezone = 'Europe/Paris';
  static const _notifId = 0;

  /// Set by app_router after GoRouter is created to enable deep-link navigation.
  static void Function(String route)? onNavigate;

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_defaultTimezone));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const windows = WindowsInitializationSettings(
      appName: 'Sirah Hub',
      appUserModelId: 'AsmaaNabi.SirahApp',
      guid: 'd49409cb-0f98-409c-a0b5-ae7de8e36286',
    );
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: android,
        iOS: ios,
        windows: windows,
      ),
      onDidReceiveNotificationResponse: _handleTap,
    );
  }

  static void _handleTap(NotificationResponse response) {
    final number = _dailyNameNumber();
    onNavigate?.call('/name/$number/experience');
  }

  /// Deterministic daily name index — mirrors NamesRepository.getDailyName().
  static int _dailyNameNumber() {
    final epoch = DateTime(2025, 1, 1);
    final days = DateTime.now().difference(epoch).inDays;
    return (days % 201) + 1;
  }

  /// Schedule (or reschedule) a daily notification at [hour]:00 local time.
  static Future<void> scheduleDailyAt(int hour) async {
    if (hour < 0 || hour > 23) {
      throw ArgumentError.value(hour, 'hour', 'Must be between 0 and 23');
    }

    if (!kIsWeb && Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    if (!kIsWeb && Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, hour);
    if (!target.isAfter(now)) {
      target = target.add(const Duration(days: 1));
    }

    final tzTarget = tz.TZDateTime.from(target, tz.local);

    await _plugin.zonedSchedule(
      id: _notifId,
      title: 'Sirah Hub',
      body: 'Aujourd’hui, entrez dans un nom du Prophète ﷺ.',
      scheduledDate: tzTarget,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
        windows: WindowsNotificationDetails(),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancel() => _plugin.cancel(id: _notifId);
}
