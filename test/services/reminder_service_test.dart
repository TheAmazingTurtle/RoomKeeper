import 'package:flutter_test/flutter_test.dart';
import 'package:roomkeeper/src/data/roomkeeper_repository.dart';
import 'package:roomkeeper/src/providers.dart';
import 'package:roomkeeper/src/services/reminder_service.dart';

import 'fake_notification_gateway.dart';

void main() {
  test('reminder service schedules and cancels owner reminders', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);
    final repository = RoomkeeperRepository(database);
    final notifications = FakeNotificationGateway();
    final service = ReminderService(
      repository: repository,
      notifications: notifications,
    );

    await service.initialize();
    expect(notifications.initialized, isTrue);
    expect(notifications.permissionRequested, isTrue);

    await repository.ensureDefaults();
    final todoId = await repository.addTodoItem(title: 'Take trash out');
    await service.rescheduleOwnerReminder(
      ownerType: 'todo',
      ownerId: todoId,
      title: 'Task: Take trash out',
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
    );

    final active = await repository.getActiveRemindersFor('todo', todoId);
    expect(active, hasLength(1));
    expect(notifications.scheduled, hasLength(1));

    await service.cancelOwnerReminders(ownerType: 'todo', ownerId: todoId);
    expect(notifications.cancelled, [active.single.notificationId]);
    expect(await repository.getActiveRemindersFor('todo', todoId), isEmpty);
  });
}
