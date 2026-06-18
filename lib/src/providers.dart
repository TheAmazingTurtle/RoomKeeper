import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'data/roomkeeper_repository.dart';
import 'services/backup_service.dart';
import 'services/image_storage_service.dart';
import 'services/notification_gateway.dart';
import 'services/reminder_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final repositoryProvider = Provider<RoomkeeperRepository>((ref) {
  return RoomkeeperRepository(ref.watch(databaseProvider));
});

final notificationGatewayProvider = Provider<LocalNotificationGateway>((ref) {
  return FlutterLocalNotificationGateway();
});

final reminderServiceProvider = Provider<ReminderService>((ref) {
  return ReminderService(
    repository: ref.watch(repositoryProvider),
    notifications: ref.watch(notificationGatewayProvider),
  );
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

final imageStorageServiceProvider = Provider<ImageStorageService>((ref) {
  return ImageStorageService();
});

final appStartupProvider = FutureProvider<void>((ref) async {
  await ref.watch(repositoryProvider).ensureDefaults();
  await ref.watch(reminderServiceProvider).initialize();
});

final areasProvider = StreamProvider<List<Area>>((ref) {
  return ref.watch(repositoryProvider).watchAreas();
});

final inventoryProvider = StreamProvider<List<InventoryItem>>((ref) {
  return ref.watch(repositoryProvider).watchInventoryItems();
});

final foodProvider = StreamProvider<List<FoodStock>>((ref) {
  return ref.watch(repositoryProvider).watchFoodStocks();
});

final laundryProvider = StreamProvider<List<LaundryLog>>((ref) {
  return ref.watch(repositoryProvider).watchLaundryLogs();
});

final laundryBasketProvider = StreamProvider<List<LaundryBasketItem>>((ref) {
  return ref.watch(repositoryProvider).watchLaundryBasketItems();
});

final paymentsProvider = StreamProvider<List<PaymentLog>>((ref) {
  return ref.watch(repositoryProvider).watchPaymentLogs();
});

final todosProvider = StreamProvider<List<TodoItem>>((ref) {
  return ref.watch(repositoryProvider).watchTodoItems();
});

final activeRemindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(repositoryProvider).watchActiveReminders();
});

final primaryLayoutProvider = StreamProvider<RoomLayout?>((ref) {
  return ref.watch(repositoryProvider).watchPrimaryLayout();
});

final layoutObjectsProvider = StreamProvider.family<List<LayoutObject>, int>((
  ref,
  layoutId,
) {
  return ref.watch(repositoryProvider).watchLayoutObjects(layoutId);
});

final layoutCellsProvider = StreamProvider.family<List<LayoutCell>, int>((
  ref,
  layoutId,
) {
  return ref.watch(repositoryProvider).watchLayoutCells(layoutId);
});

AppDatabase inMemoryDatabaseForTests() {
  return AppDatabase(NativeDatabase.memory());
}
