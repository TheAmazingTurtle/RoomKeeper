import 'package:drift/drift.dart';

import 'database.dart';

const defaultAreaSpecs = [
  ('Kitchen', 'kitchen', '#F97316'),
  ('Restroom', 'restroom', '#06B6D4'),
  ('Wardrobe', 'wardrobe', '#8B5CF6'),
  ('Bed', 'bed', '#10B981'),
  ('Hobby', 'hobby', '#EF4444'),
  ('Desk', 'desk', '#3B82F6'),
];

class RoomkeeperRepository {
  RoomkeeperRepository(this.db);

  final AppDatabase db;

  Stream<List<Area>> watchAreas() {
    final query = db.select(db.areas)
      ..orderBy([
        (table) => OrderingTerm(expression: table.sortOrder),
        (table) => OrderingTerm(expression: table.name),
      ]);
    return query.watch();
  }

  Future<List<Area>> getAreas() {
    final query = db.select(db.areas)
      ..orderBy([
        (table) => OrderingTerm(expression: table.sortOrder),
        (table) => OrderingTerm(expression: table.name),
      ]);
    return query.get();
  }

  Future<Area?> findAreaByName(String name) {
    return (db.select(
      db.areas,
    )..where((table) => table.name.equals(name))).getSingleOrNull();
  }

  Future<void> ensureDefaults() async {
    final hasArea = await (db.select(db.areas)..limit(1)).getSingleOrNull();
    if (hasArea == null) {
      await db.batch((batch) {
        for (var index = 0; index < defaultAreaSpecs.length; index++) {
          final spec = defaultAreaSpecs[index];
          batch.insert(
            db.areas,
            AreasCompanion.insert(
              name: spec.$1,
              type: Value(spec.$2),
              colorHex: Value(spec.$3),
              sortOrder: Value(index),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }
      });
    }

    final hasLayout = await (db.select(
      db.roomLayouts,
    )..limit(1)).getSingleOrNull();
    if (hasLayout != null) {
      return;
    }

    final now = DateTime.now();
    final layoutId = await db
        .into(db.roomLayouts)
        .insert(RoomLayoutsCompanion.insert(updatedAt: now));
    final areas = {
      for (final area in await getAreas()) area.name.toLowerCase(): area,
    };

    await db.batch((batch) {
      batch.insertAll(db.layoutObjects, [
        LayoutObjectsCompanion.insert(
          layoutId: layoutId,
          linkedAreaId: Value(areas['bed']?.id),
          label: 'Bed',
          kind: const Value('furniture'),
          x: const Value(32),
          y: const Value(320),
          width: const Value(180),
          height: const Value(150),
          colorHex: const Value('#10B981'),
          zOrder: const Value(1),
        ),
        LayoutObjectsCompanion.insert(
          layoutId: layoutId,
          linkedAreaId: Value(areas['wardrobe']?.id),
          label: 'Wardrobe',
          kind: const Value('storage'),
          x: const Value(230),
          y: const Value(320),
          width: const Value(100),
          height: const Value(150),
          colorHex: const Value('#8B5CF6'),
          zOrder: const Value(2),
        ),
        LayoutObjectsCompanion.insert(
          layoutId: layoutId,
          linkedAreaId: Value(areas['kitchen']?.id),
          label: 'Kitchen shelf',
          kind: const Value('storage'),
          x: const Value(24),
          y: const Value(28),
          width: const Value(135),
          height: const Value(92),
          colorHex: const Value('#F97316'),
          zOrder: const Value(3),
        ),
        LayoutObjectsCompanion.insert(
          layoutId: layoutId,
          linkedAreaId: Value(areas['restroom']?.id),
          label: 'Restroom',
          kind: const Value('fixture'),
          x: const Value(222),
          y: const Value(26),
          width: const Value(108),
          height: const Value(118),
          colorHex: const Value('#06B6D4'),
          zOrder: const Value(4),
        ),
      ]);
    });
  }

  Future<int> addArea({
    required String name,
    String type = 'custom',
    String colorHex = '#3B82F6',
  }) async {
    final count = await (db.select(db.areas)).get().then((rows) => rows.length);
    return db
        .into(db.areas)
        .insert(
          AreasCompanion.insert(
            name: name.trim(),
            type: Value(type),
            colorHex: Value(colorHex),
            sortOrder: Value(count + 1),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Stream<List<InventoryItem>> watchInventoryItems() {
    final query = db.select(db.inventoryItems)
      ..orderBy([(table) => OrderingTerm(expression: table.name)]);
    return query.watch();
  }

  Future<List<InventoryItem>> getInventoryItems() {
    return (db.select(
      db.inventoryItems,
    )..orderBy([(table) => OrderingTerm(expression: table.name)])).get();
  }

  Future<int> addInventoryItem({
    required String name,
    int? areaId,
    int quantity = 1,
    String condition = 'Good',
    String? notes,
    String? photoPath,
  }) {
    final now = DateTime.now();
    return db
        .into(db.inventoryItems)
        .insert(
          InventoryItemsCompanion.insert(
            areaId: Value<int?>(areaId),
            name: name.trim(),
            quantity: Value(quantity),
            condition: Value(condition),
            notes: Value<String?>(notes?.trim().isEmpty ?? true ? null : notes),
            photoPath: Value<String?>(photoPath),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> updateInventoryItem(InventoryItem item) {
    return (db.update(db.inventoryItems)
          ..where((table) => table.id.equals(item.id)))
        .write(item.toCompanion(true));
  }

  Future<void> deleteInventoryItem(int id) {
    return (db.delete(
      db.inventoryItems,
    )..where((table) => table.id.equals(id))).go();
  }

  Stream<List<FoodStock>> watchFoodStocks() {
    final query = db.select(db.foodStocks)
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.expiryDate, nulls: NullsOrder.last),
        (table) => OrderingTerm(expression: table.name),
      ]);
    return query.watch();
  }

  Future<List<FoodStock>> getFoodStocks() {
    return (db.select(db.foodStocks)..orderBy([
          (table) => OrderingTerm(
            expression: table.expiryDate,
            nulls: NullsOrder.last,
          ),
          (table) => OrderingTerm(expression: table.name),
        ]))
        .get();
  }

  Future<int> addFoodStock({
    required String name,
    int? areaId,
    String category = 'Pantry',
    double quantity = 1,
    String unit = 'pcs',
    DateTime? expiryDate,
    double? lowStockThreshold,
    String? notes,
  }) {
    final now = DateTime.now();
    return db
        .into(db.foodStocks)
        .insert(
          FoodStocksCompanion.insert(
            areaId: Value<int?>(areaId),
            name: name.trim(),
            category: Value(
              category.trim().isEmpty ? 'Pantry' : category.trim(),
            ),
            quantity: Value(quantity),
            unit: Value(unit.trim().isEmpty ? 'pcs' : unit.trim()),
            expiryDate: Value<DateTime?>(expiryDate),
            lowStockThreshold: Value<double?>(lowStockThreshold),
            notes: Value<String?>(notes?.trim().isEmpty ?? true ? null : notes),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> updateFoodStock(FoodStock food) {
    return (db.update(db.foodStocks)
          ..where((table) => table.id.equals(food.id)))
        .write(food.toCompanion(true));
  }

  Future<void> deleteFoodStock(int id) {
    return (db.delete(
      db.foodStocks,
    )..where((table) => table.id.equals(id))).go();
  }

  Stream<List<LaundryLog>> watchLaundryLogs() {
    final query = db.select(db.laundryLogs)
      ..orderBy([
        (table) => OrderingTerm(
          expression: table.completedAt,
          mode: OrderingMode.desc,
        ),
      ]);
    return query.watch();
  }

  Future<int> addLaundryLog({
    required DateTime completedAt,
    DateTime? nextReminderAt,
    String? notes,
  }) {
    return db
        .into(db.laundryLogs)
        .insert(
          LaundryLogsCompanion.insert(
            completedAt: completedAt,
            notes: Value<String?>(notes?.trim().isEmpty ?? true ? null : notes),
            nextReminderAt: Value<DateTime?>(nextReminderAt),
          ),
        );
  }

  Stream<List<PaymentLog>> watchPaymentLogs() {
    final query = db.select(db.paymentLogs)
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.paidAt, mode: OrderingMode.desc),
      ]);
    return query.watch();
  }

  Future<int> addPaymentLog({
    required String billType,
    required String billingMonth,
    required DateTime paidAt,
    required int amountCents,
    DateTime? nextReminderAt,
    String? notes,
  }) {
    return db
        .into(db.paymentLogs)
        .insert(
          PaymentLogsCompanion.insert(
            billType: Value(billType),
            billingMonth: billingMonth,
            paidAt: paidAt,
            amountCents: Value(amountCents),
            notes: Value<String?>(notes?.trim().isEmpty ?? true ? null : notes),
            nextReminderAt: Value<DateTime?>(nextReminderAt),
          ),
        );
  }

  Stream<List<TodoItem>> watchTodoItems() {
    final query = db.select(db.todoItems)
      ..orderBy([
        (table) => OrderingTerm(expression: table.isDone),
        (table) =>
            OrderingTerm(expression: table.dueAt, nulls: NullsOrder.last),
        (table) =>
            OrderingTerm(expression: table.createdAt, mode: OrderingMode.desc),
      ]);
    return query.watch();
  }

  Future<int> addTodoItem({
    required String title,
    String? notes,
    DateTime? dueAt,
    DateTime? reminderAt,
  }) {
    final now = DateTime.now();
    return db
        .into(db.todoItems)
        .insert(
          TodoItemsCompanion.insert(
            title: title.trim(),
            notes: Value<String?>(notes?.trim().isEmpty ?? true ? null : notes),
            dueAt: Value<DateTime?>(dueAt),
            reminderAt: Value<DateTime?>(reminderAt),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> toggleTodoItem(TodoItem item) {
    return (db.update(
      db.todoItems,
    )..where((table) => table.id.equals(item.id))).write(
      TodoItemsCompanion(
        isDone: Value(!item.isDone),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteTodoItem(int id) {
    return (db.delete(
      db.todoItems,
    )..where((table) => table.id.equals(id))).go();
  }

  Stream<RoomLayout?> watchPrimaryLayout() {
    final query = db.select(db.roomLayouts)..limit(1);
    return query.watchSingleOrNull();
  }

  Future<RoomLayout?> getPrimaryLayout() {
    return (db.select(db.roomLayouts)..limit(1)).getSingleOrNull();
  }

  Stream<List<LayoutObject>> watchLayoutObjects(int layoutId) {
    final query = db.select(db.layoutObjects)
      ..where((table) => table.layoutId.equals(layoutId))
      ..orderBy([(table) => OrderingTerm(expression: table.zOrder)]);
    return query.watch();
  }

  Future<List<LayoutObject>> getLayoutObjects(int layoutId) {
    return (db.select(db.layoutObjects)
          ..where((table) => table.layoutId.equals(layoutId))
          ..orderBy([(table) => OrderingTerm(expression: table.zOrder)]))
        .get();
  }

  Future<int> addLayoutObject({
    required int layoutId,
    required String label,
    int? linkedAreaId,
    String kind = 'zone',
    double x = 20,
    double y = 20,
    double width = 110,
    double height = 80,
    String colorHex = '#3B82F6',
  }) async {
    final existing = await getLayoutObjects(layoutId);
    return db
        .into(db.layoutObjects)
        .insert(
          LayoutObjectsCompanion.insert(
            layoutId: layoutId,
            linkedAreaId: Value<int?>(linkedAreaId),
            label: label.trim(),
            kind: Value(kind),
            x: Value(x),
            y: Value(y),
            width: Value(width),
            height: Value(height),
            colorHex: Value(colorHex),
            zOrder: Value(existing.length + 1),
          ),
        );
  }

  Future<void> updateLayoutObject(LayoutObject object) {
    return (db.update(db.layoutObjects)
          ..where((table) => table.id.equals(object.id)))
        .write(object.toCompanion(true));
  }

  Future<void> deleteLayoutObject(int id) {
    return (db.delete(
      db.layoutObjects,
    )..where((table) => table.id.equals(id))).go();
  }

  Stream<List<Reminder>> watchActiveReminders() {
    final query = db.select(db.reminders)
      ..where((table) => table.status.equals('active'))
      ..orderBy([(table) => OrderingTerm(expression: table.scheduledAt)]);
    return query.watch();
  }

  Future<List<Reminder>> getActiveRemindersFor(String ownerType, int ownerId) {
    return (db.select(db.reminders)..where(
          (table) =>
              table.ownerType.equals(ownerType) &
              table.ownerId.equals(ownerId) &
              table.status.equals('active'),
        ))
        .get();
  }

  Future<List<Reminder>> getActiveReminders() {
    return (db.select(db.reminders)
          ..where((table) => table.status.equals('active'))
          ..orderBy([(table) => OrderingTerm(expression: table.scheduledAt)]))
        .get();
  }

  Future<int> addReminder({
    required String ownerType,
    required int ownerId,
    required String title,
    required DateTime scheduledAt,
    required int notificationId,
    String? body,
  }) {
    final now = DateTime.now();
    return db
        .into(db.reminders)
        .insert(
          RemindersCompanion.insert(
            ownerType: ownerType,
            ownerId: Value(ownerId),
            title: title,
            body: Value<String?>(body),
            scheduledAt: scheduledAt,
            notificationId: notificationId,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> markReminderCancelled(int id) {
    return (db.update(
      db.reminders,
    )..where((table) => table.id.equals(id))).write(
      RemindersCompanion(
        status: const Value('cancelled'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markReminderComplete(int id) {
    return (db.update(
      db.reminders,
    )..where((table) => table.id.equals(id))).write(
      RemindersCompanion(
        status: const Value('completed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
