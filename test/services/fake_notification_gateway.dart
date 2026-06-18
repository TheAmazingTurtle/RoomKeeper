import 'package:roomkeeper/src/services/notification_gateway.dart';

class ScheduledNotification {
  ScheduledNotification({
    required this.id,
    required this.title,
    required this.scheduledAt,
    this.body,
  });

  final int id;
  final String title;
  final DateTime scheduledAt;
  final String? body;
}

class FakeNotificationGateway implements LocalNotificationGateway {
  bool initialized = false;
  bool permissionRequested = false;
  bool permissionGranted = true;
  bool failSchedule = false;
  final scheduled = <ScheduledNotification>[];
  final cancelled = <int>[];

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    permissionRequested = true;
    return permissionGranted;
  }

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required DateTime scheduledAt,
    String? body,
  }) async {
    if (failSchedule) {
      throw StateError('Scheduling failed.');
    }
    scheduled.add(
      ScheduledNotification(
        id: id,
        title: title,
        body: body,
        scheduledAt: scheduledAt,
      ),
    );
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }
}
