import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/app.dart';
import 'package:sirah_app/core/notifications/notification_service.dart';
import 'package:sirah_app/core/storage/hive_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveSource.init();
  await NotificationService.init();

  // Reschedule in case the OS cleared notifications (reboot, reinstall, etc.)
  final savedHour = HiveSource.read().dailyNotifHour;
  if (savedHour != null) {
    await NotificationService.scheduleDailyAt(savedHour);
  }

  runApp(const ProviderScope(child: App()));
}
