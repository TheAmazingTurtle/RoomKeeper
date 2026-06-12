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

  Future<void> initialize() async {
    await _notifications.initialize();
    await _notifications.requestPermission();
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

    final notificationId = _nextNotificationId(ownerType, ownerId, scheduledAt);
    final reminderId = await _repository.addReminder(
      ownerType: ownerType,
      ownerId: ownerId,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
      notificationId: notificationId,
    );
    await _notifications.schedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
    );
    return reminderId;
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
}
