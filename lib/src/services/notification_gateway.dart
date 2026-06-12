import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

abstract class LocalNotificationGateway {
  Future<void> initialize();

  Future<bool> requestPermission();

  Future<void> schedule({
    required int id,
    required String title,
    required DateTime scheduledAt,
    String? body,
  });

  Future<void> cancel(int id);
}

class FlutterLocalNotificationGateway implements LocalNotificationGateway {
  FlutterLocalNotificationGateway({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const _channelId = 'roomkeeper_reminders';
  static const _channelName = 'RoomKeeper reminders';

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Manila'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestNotificationsPermission() ?? true;
  }

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required DateTime scheduledAt,
    String? body,
  }) async {
    await initialize();
    if (!scheduledAt.isAfter(DateTime.now())) {
      return;
    }

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription:
              'Laundry, payment, utility, and room task reminders.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(int id) {
    return _plugin.cancel(id: id);
  }
}
