import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import 'database.dart';

typedef LayoutCellPosition = ({int column, int row});

const defaultAreaSpecs = [
  ('Kitchen', 'kitchen', '#F97316'),
  ('Restroom', 'restroom', '#06B6D4'),
  ('Wardrobe', 'wardrobe', '#8B5CF6'),
  ('Bed', 'bed', '#10B981'),
  ('Hobby', 'hobby', '#EF4444'),
  ('Desk', 'desk', '#3B82F6'),
];

const defaultLaundryBasketItems = ['Shirt', 'Underwear', 'Shorts', 'Pants'];

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
      await ensureLaundryBasketDefaults();
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
    await ensureLaundryBasketDefaults();
  }

  Future<void> ensureLaundryBasketDefaults() async {
    final existing = await db.select(db.laundryBasketItems).get();
    final existingNames = {
      for (final item in existing) item.name.trim().toLowerCase(),
    };
    final now = DateTime.now();
    await db.batch((batch) {
      for (var index = 0; index < defaultLaundryBasketItems.length; index++) {
        final name = defaultLaundryBasketItems[index];
        if (existingNames.contains(name.toLowerCase())) continue;
        batch.insert(
          db.laundryBasketItems,
          LaundryBasketItemsCompanion.insert(
            name: name,
            isDefault: const Value(true),
            sortOrder: Value(index),
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
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

  Future<void> changeInventoryQuantity(InventoryItem item, int delta) {
    final next = (item.quantity + delta).clamp(0, 999).toInt();
    return (db.update(
      db.inventoryItems,
    )..where((table) => table.id.equals(item.id))).write(
      InventoryItemsCompanion(
        quantity: Value(next),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteInventoryItem(int id) async {
    final item = await (db.select(
      db.inventoryItems,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    await (db.delete(
      db.inventoryItems,
    )..where((table) => table.id.equals(id))).go();
    await _deleteManagedInventoryPhoto(item?.photoPath);
  }

  Future<void> _deleteManagedInventoryPhoto(String? photoPath) async {
    if (photoPath == null) return;
    if (!p.split(photoPath).contains('inventory_photos')) return;
    final file = File(photoPath);
    if (await file.exists()) {
      await file.delete();
    }
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

  Future<void> changeFoodQuantity(FoodStock food, double delta) {
    final next = (food.quantity + delta).clamp(0, 999).toDouble();
    return (db.update(
      db.foodStocks,
    )..where((table) => table.id.equals(food.id))).write(
      FoodStocksCompanion(
        quantity: Value(next),
        updatedAt: Value(DateTime.now()),
      ),
    );
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

  Future<List<LaundryLog>> getLaundryLogs() {
    final query = db.select(db.laundryLogs)
      ..orderBy([
        (table) => OrderingTerm(
          expression: table.completedAt,
          mode: OrderingMode.desc,
        ),
      ]);
    return query.get();
  }

  Future<void> updateLaundryLog({
    required int id,
    required DateTime completedAt,
    DateTime? nextReminderAt,
    String? notes,
  }) {
    return (db.update(
      db.laundryLogs,
    )..where((table) => table.id.equals(id))).write(
      LaundryLogsCompanion(
        completedAt: Value(completedAt),
        nextReminderAt: Value<DateTime?>(nextReminderAt),
        notes: Value<String?>(notes?.trim().isEmpty ?? true ? null : notes),
      ),
    );
  }

  Future<void> deleteLaundryLog(int id) {
    return (db.delete(
      db.laundryLogs,
    )..where((table) => table.id.equals(id))).go();
  }

  Stream<List<LaundryBasketItem>> watchLaundryBasketItems() {
    final query = db.select(db.laundryBasketItems)
      ..orderBy([
        (table) => OrderingTerm(expression: table.sortOrder),
        (table) => OrderingTerm(expression: table.name),
      ]);
    return query.watch();
  }

  Future<List<LaundryBasketItem>> getLaundryBasketItems() {
    return (db.select(db.laundryBasketItems)..orderBy([
          (table) => OrderingTerm(expression: table.sortOrder),
          (table) => OrderingTerm(expression: table.name),
        ]))
        .get();
  }

  Future<int> addLaundryBasketItem(String name) async {
    final count = await db
        .select(db.laundryBasketItems)
        .get()
        .then((rows) => rows.length);
    final now = DateTime.now();
    return db
        .into(db.laundryBasketItems)
        .insert(
          LaundryBasketItemsCompanion.insert(
            name: name.trim(),
            sortOrder: Value(count),
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> changeLaundryBasketCount(LaundryBasketItem item, int delta) {
    final next = (item.count + delta).clamp(0, 999).toInt();
    return (db.update(
      db.laundryBasketItems,
    )..where((table) => table.id.equals(item.id))).write(
      LaundryBasketItemsCompanion(
        count: Value(next),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> resetLaundryBasketCounts() {
    return db
        .update(db.laundryBasketItems)
        .write(
          LaundryBasketItemsCompanion(
            count: const Value(0),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> deleteLaundryBasketItem(int id) {
    return (db.delete(
      db.laundryBasketItems,
    )..where((table) => table.id.equals(id))).go();
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

  Future<List<PaymentLog>> getPaymentLogs() {
    final query = db.select(db.paymentLogs)
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.paidAt, mode: OrderingMode.desc),
      ]);
    return query.get();
  }

  Future<void> updatePaymentLog({
    required int id,
    required String billType,
    required String billingMonth,
    required DateTime paidAt,
    required int amountCents,
    DateTime? nextReminderAt,
    String? notes,
  }) {
    return (db.update(
      db.paymentLogs,
    )..where((table) => table.id.equals(id))).write(
      PaymentLogsCompanion(
        billType: Value(billType),
        billingMonth: Value(billingMonth),
        paidAt: Value(paidAt),
        amountCents: Value(amountCents),
        notes: Value<String?>(notes?.trim().isEmpty ?? true ? null : notes),
        nextReminderAt: Value<DateTime?>(nextReminderAt),
      ),
    );
  }

  Future<void> deletePaymentLog(int id) {
    return (db.delete(
      db.paymentLogs,
    )..where((table) => table.id.equals(id))).go();
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

  Future<List<TodoItem>> getTodoItems() {
    return (db.select(db.todoItems)..orderBy([
          (table) => OrderingTerm(expression: table.isDone),
          (table) =>
              OrderingTerm(expression: table.dueAt, nulls: NullsOrder.last),
          (table) => OrderingTerm(
            expression: table.createdAt,
            mode: OrderingMode.desc,
          ),
        ]))
        .get();
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

  Future<void> updateTodoItem({
    required int id,
    required String title,
    String? notes,
    DateTime? dueAt,
    DateTime? reminderAt,
  }) {
    return (db.update(
      db.todoItems,
    )..where((table) => table.id.equals(id))).write(
      TodoItemsCompanion(
        title: Value(title.trim()),
        notes: Value<String?>(notes?.trim().isEmpty ?? true ? null : notes),
        dueAt: Value<DateTime?>(dueAt),
        reminderAt: Value<DateTime?>(reminderAt),
        updatedAt: Value(DateTime.now()),
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

  Stream<List<LayoutCell>> watchLayoutCells(int layoutId) {
    final query = db.select(db.layoutCells)
      ..where((table) => table.layoutId.equals(layoutId))
      ..orderBy([
        (table) => OrderingTerm(expression: table.row),
        (table) => OrderingTerm(expression: table.column),
      ]);
    return query.watch();
  }

  Future<List<LayoutCell>> getLayoutCells(int layoutId) {
    return (db.select(db.layoutCells)
          ..where((table) => table.layoutId.equals(layoutId))
          ..orderBy([
            (table) => OrderingTerm(expression: table.row),
            (table) => OrderingTerm(expression: table.column),
          ]))
        .get();
  }

  Future<void> replaceLayoutObjectCells({
    required LayoutObject object,
    required Set<LayoutCellPosition> cells,
  }) async {
    if (cells.isEmpty) {
      throw ArgumentError.value(cells, 'cells', 'A room area needs cells.');
    }
    if (!_isContiguous(cells)) {
      throw ArgumentError.value(
        cells,
        'cells',
        'Room area cells must stay connected.',
      );
    }

    await db.transaction(() async {
      await (db.delete(
        db.layoutCells,
      )..where((table) => table.layoutObjectId.equals(object.id))).go();
      for (final cell in cells) {
        await (db.delete(db.layoutCells)..where(
              (table) =>
                  table.layoutId.equals(object.layoutId) &
                  table.column.equals(cell.column) &
                  table.row.equals(cell.row),
            ))
            .go();
        await db
            .into(db.layoutCells)
            .insert(
              LayoutCellsCompanion.insert(
                layoutId: object.layoutId,
                layoutObjectId: object.id,
                column: cell.column,
                row: cell.row,
              ),
            );
      }
    });
  }

  Future<void> deleteLayoutObject(int id) async {
    await (db.delete(
      db.layoutCells,
    )..where((table) => table.layoutObjectId.equals(id))).go();
    await (db.delete(
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

bool _isContiguous(Set<LayoutCellPosition> cells) {
  if (cells.length <= 1) return true;
  final remaining = cells.toSet();
  final queue = <LayoutCellPosition>[remaining.first];
  remaining.remove(queue.first);

  while (queue.isNotEmpty) {
    final current = queue.removeLast();
    final neighbors = [
      (column: current.column + 1, row: current.row),
      (column: current.column - 1, row: current.row),
      (column: current.column, row: current.row + 1),
      (column: current.column, row: current.row - 1),
    ];
    for (final neighbor in neighbors) {
      if (remaining.remove(neighbor)) {
        queue.add(neighbor);
      }
    }
  }

  return remaining.isEmpty;
}
