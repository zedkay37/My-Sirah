import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/app.dart';
import 'package:sirah_app/core/notifications/notification_service.dart';
import 'package:sirah_app/core/storage/hive_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveSource.init();
  unawaited(_bootstrapNotifications());

  runApp(const ProviderScope(child: App()));
}

Future<void> _bootstrapNotifications() async {
  try {
    await NotificationService.init();

    // Reschedule in case the OS cleared notifications (reboot, reinstall, etc.)
    final savedHour = HiveSource.read().dailyNotifHour;
    if (savedHour != null) {
      await NotificationService.scheduleDailyAt(savedHour);
    }
  } catch (error, stackTrace) {
    debugPrint('Notification bootstrap failed: $error');
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'sirah_app.notifications',
        context: ErrorDescription('while bootstrapping notifications'),
      ),
    );
  }
}
