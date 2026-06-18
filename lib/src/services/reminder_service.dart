import '../data/roomkeeper_repository.dart';
import 'notification_gateway.dart';

class ReminderService {
  ReminderService({
    required RoomkeeperRepository repository,
    required LocalNotificationGateway notifications,
  }) : _repository = repository,
       _notifications = notifications;

  final RoomkeeperRepository _repository;
  final LocalNotificationGateway _notifications;
  bool _permissionGranted = true;

  Future<void> initialize() async {
    await _notifications.initialize();
    _permissionGranted = await _notifications.requestPermission();
  }

  Future<int?> rescheduleOwnerReminder({
    required String ownerType,
    required int ownerId,
    required String title,
    required DateTime? scheduledAt,
    String? body,
  }) async {
    await cancelOwnerReminders(ownerType: ownerType, ownerId: ownerId);
    if (scheduledAt == null) {
      return null;
    }
    _validateSchedulable(scheduledAt);

    final notificationId = _nextNotificationId(ownerType, ownerId, scheduledAt);
    await _scheduleNotification(
      id: notificationId,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
    );
    final reminderId = await _repository.addReminder(
      ownerType: ownerType,
      ownerId: ownerId,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
      notificationId: notificationId,
    );
    return reminderId;
  }

  Future<void> rescheduleActiveReminders() async {
    final active = await _repository.getActiveReminders();
    for (final reminder in active) {
      if (!reminder.scheduledAt.isAfter(DateTime.now())) {
        await _repository.markReminderCancelled(reminder.id);
        continue;
      }
      try {
        await _scheduleNotification(
          id: reminder.notificationId,
          title: reminder.title,
          body: reminder.body,
          scheduledAt: reminder.scheduledAt,
        );
      } catch (_) {
        await _repository.markReminderCancelled(reminder.id);
      }
    }
  }

  Future<void> cancelOwnerReminders({
    required String ownerType,
    required int ownerId,
  }) async {
    final active = await _repository.getActiveRemindersFor(ownerType, ownerId);
    for (final reminder in active) {
      await _notifications.cancel(reminder.notificationId);
      await _repository.markReminderCancelled(reminder.id);
    }
  }

  int _nextNotificationId(String ownerType, int ownerId, DateTime scheduledAt) {
    final raw = Object.hash(
      ownerType,
      ownerId,
      scheduledAt.millisecondsSinceEpoch,
      DateTime.now().microsecondsSinceEpoch,
    );
    return raw.abs() % 2147483647;
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required DateTime scheduledAt,
    String? body,
  }) async {
    _validateSchedulable(scheduledAt);
    if (!_permissionGranted) {
      throw StateError('Notification permission was not granted.');
    }
    await _notifications.schedule(
      id: id,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
    );
  }

  void _validateSchedulable(DateTime scheduledAt) {
    if (!scheduledAt.isAfter(DateTime.now())) {
      throw ArgumentError.value(
        scheduledAt,
        'scheduledAt',
        'Reminder time must be in the future.',
      );
    }
  }
}
