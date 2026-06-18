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

  test('reminder service reschedules edited task and log reminders', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);
    final repository = RoomkeeperRepository(database);
    final notifications = FakeNotificationGateway();
    final service = ReminderService(
      repository: repository,
      notifications: notifications,
    );

    await service.initialize();
    final firstReminder = DateTime.now().add(const Duration(days: 1));
    final editedReminder = DateTime.now().add(const Duration(days: 2));
    final todoId = await repository.addTodoItem(
      title: 'Clean sink',
      reminderAt: firstReminder,
    );
    await service.rescheduleOwnerReminder(
      ownerType: 'todo',
      ownerId: todoId,
      title: 'Task: Clean sink',
      scheduledAt: firstReminder,
    );
    final firstNotificationId = notifications.scheduled.single.id;

    await repository.updateTodoItem(
      id: todoId,
      title: 'Clean shelf',
      reminderAt: editedReminder,
    );
    await service.rescheduleOwnerReminder(
      ownerType: 'todo',
      ownerId: todoId,
      title: 'Task: Clean shelf',
      scheduledAt: editedReminder,
    );

    expect(notifications.cancelled, [firstNotificationId]);
    expect(notifications.scheduled, hasLength(2));
    final active = await repository.getActiveRemindersFor('todo', todoId);
    expect(active, hasLength(1));
    expect(active.single.title, 'Task: Clean shelf');
  });

  test('reminder service rejects past reminders before saving', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);
    final repository = RoomkeeperRepository(database);
    final notifications = FakeNotificationGateway();
    final service = ReminderService(
      repository: repository,
      notifications: notifications,
    );

    await service.initialize();
    await repository.ensureDefaults();
    final todoId = await repository.addTodoItem(title: 'Take trash out');

    await expectLater(
      service.rescheduleOwnerReminder(
        ownerType: 'todo',
        ownerId: todoId,
        title: 'Task: Take trash out',
        scheduledAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      throwsArgumentError,
    );
    expect(await repository.getActiveRemindersFor('todo', todoId), isEmpty);
    expect(notifications.scheduled, isEmpty);
  });

  test(
    'reminder service does not save active reminder when scheduling fails',
    () async {
      final database = inMemoryDatabaseForTests();
      addTearDown(database.close);
      final repository = RoomkeeperRepository(database);
      final notifications = FakeNotificationGateway()..failSchedule = true;
      final service = ReminderService(
        repository: repository,
        notifications: notifications,
      );

      await service.initialize();
      await repository.ensureDefaults();
      final todoId = await repository.addTodoItem(title: 'Take trash out');

      await expectLater(
        service.rescheduleOwnerReminder(
          ownerType: 'todo',
          ownerId: todoId,
          title: 'Task: Take trash out',
          scheduledAt: DateTime.now().add(const Duration(days: 1)),
        ),
        throwsStateError,
      );
      expect(await repository.getActiveRemindersFor('todo', todoId), isEmpty);
    },
  );

  test('reminder service surfaces notification permission denial', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);
    final repository = RoomkeeperRepository(database);
    final notifications = FakeNotificationGateway()..permissionGranted = false;
    final service = ReminderService(
      repository: repository,
      notifications: notifications,
    );

    await service.initialize();
    await repository.ensureDefaults();
    final todoId = await repository.addTodoItem(title: 'Take trash out');

    await expectLater(
      service.rescheduleOwnerReminder(
        ownerType: 'todo',
        ownerId: todoId,
        title: 'Task: Take trash out',
        scheduledAt: DateTime.now().add(const Duration(days: 1)),
      ),
      throwsStateError,
    );
    expect(await repository.getActiveRemindersFor('todo', todoId), isEmpty);
  });

  test(
    'reminder service reschedules future imported active reminders',
    () async {
      final database = inMemoryDatabaseForTests();
      addTearDown(database.close);
      final repository = RoomkeeperRepository(database);
      final notifications = FakeNotificationGateway();
      final service = ReminderService(
        repository: repository,
        notifications: notifications,
      );

      await service.initialize();
      final future = DateTime.now().add(const Duration(days: 2));
      final past = DateTime.now().subtract(const Duration(days: 1));
      await repository.addReminder(
        ownerType: 'todo',
        ownerId: 1,
        title: 'Future task',
        scheduledAt: future,
        notificationId: 10,
      );
      await repository.addReminder(
        ownerType: 'todo',
        ownerId: 2,
        title: 'Past task',
        scheduledAt: past,
        notificationId: 11,
      );

      await service.rescheduleActiveReminders();

      expect(notifications.scheduled.map((item) => item.id), [10]);
      expect(await repository.getActiveRemindersFor('todo', 1), hasLength(1));
      expect(await repository.getActiveRemindersFor('todo', 2), isEmpty);
    },
  );
}
