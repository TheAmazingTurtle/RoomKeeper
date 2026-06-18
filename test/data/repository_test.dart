import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' show Value;
import 'package:roomkeeper/src/data/roomkeeper_repository.dart';
import 'package:roomkeeper/src/providers.dart';

void main() {
  test('repository seeds defaults and stores core room records', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);
    final repository = RoomkeeperRepository(database);

    await repository.ensureDefaults();
    final areas = await repository.getAreas();
    expect(areas.map((area) => area.name), containsAll(['Kitchen', 'Bed']));

    final kitchen = areas.firstWhere((area) => area.name == 'Kitchen');
    await repository.addInventoryItem(
      name: 'Rice cooker',
      areaId: kitchen.id,
      quantity: 1,
      condition: 'Good',
    );
    await repository.addFoodStock(
      name: 'Eggs',
      areaId: kitchen.id,
      quantity: 6,
      unit: 'pcs',
      lowStockThreshold: 12,
      expiryDate: DateTime.now().add(const Duration(days: 5)),
    );
    await repository.addTodoItem(title: 'Clean sink');

    expect(await repository.getInventoryItems(), hasLength(1));
    expect(await repository.getFoodStocks(), hasLength(1));
    expect(
      (await repository.getLaundryBasketItems()).map((item) => item.name),
      containsAll(defaultLaundryBasketItems),
    );
    expect(await repository.getPrimaryLayout(), isNotNull);
  });

  test(
    'repository updates room item fields and preserves photo path',
    () async {
      final database = inMemoryDatabaseForTests();
      addTearDown(database.close);
      final repository = RoomkeeperRepository(database);

      await repository.ensureDefaults();
      final areas = await repository.getAreas();
      final kitchen = areas.firstWhere((area) => area.name == 'Kitchen');
      final bed = areas.firstWhere((area) => area.name == 'Bed');
      await repository.addInventoryItem(
        name: 'Fan',
        areaId: kitchen.id,
        quantity: 1,
        condition: 'Good',
        notes: 'Near window',
        photoPath: 'inventory_photos/fan.jpg',
      );

      final item = (await repository.getInventoryItems()).single;
      await repository.updateInventoryItem(
        item.copyWith(
          name: 'Desk fan',
          areaId: Value(bed.id),
          quantity: 2,
          condition: 'Used',
          notes: const Value('Moved beside bed'),
        ),
      );

      final updated = (await repository.getInventoryItems()).single;
      expect(updated.name, 'Desk fan');
      expect(updated.areaId, bed.id);
      expect(updated.quantity, 2);
      expect(updated.condition, 'Used');
      expect(updated.notes, 'Moved beside bed');
      expect(updated.photoPath, 'inventory_photos/fan.jpg');
    },
  );

  test(
    'repository updates food stock fields that drive attention status',
    () async {
      final database = inMemoryDatabaseForTests();
      addTearDown(database.close);
      final repository = RoomkeeperRepository(database);

      await repository.ensureDefaults();
      final areas = await repository.getAreas();
      final kitchen = areas.firstWhere((area) => area.name == 'Kitchen');
      final bed = areas.firstWhere((area) => area.name == 'Bed');
      final expiry = DateTime.now().add(const Duration(days: 3));
      await repository.addFoodStock(
        name: 'Eggs',
        areaId: kitchen.id,
        category: 'Fridge',
        quantity: 6,
        unit: 'pcs',
        expiryDate: expiry,
        lowStockThreshold: 12,
        notes: 'Buy weekly',
      );

      final food = (await repository.getFoodStocks()).single;
      final laterExpiry = expiry.add(const Duration(days: 10));
      await repository.updateFoodStock(
        food.copyWith(
          name: 'Brown eggs',
          areaId: Value(bed.id),
          category: 'Breakfast',
          quantity: 18,
          unit: 'pcs',
          expiryDate: Value(laterExpiry),
          lowStockThreshold: const Value(6),
          notes: const Value('Restocked'),
        ),
      );

      final updated = (await repository.getFoodStocks()).single;
      expect(updated.name, 'Brown eggs');
      expect(updated.areaId, bed.id);
      expect(updated.category, 'Breakfast');
      expect(updated.quantity, 18);
      expect(
        updated.expiryDate!.difference(laterExpiry).inSeconds.abs(),
        lessThanOrEqualTo(1),
      );
      expect(updated.lowStockThreshold, 6);
      expect(updated.notes, 'Restocked');
    },
  );

  test('repository adjusts inventory and food quantities inline', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);
    final repository = RoomkeeperRepository(database);

    await repository.addInventoryItem(name: 'Mug', quantity: 2);
    var item = (await repository.getInventoryItems()).single;
    await repository.changeInventoryQuantity(item, 1);
    item = (await repository.getInventoryItems()).single;
    expect(item.quantity, 3);
    await repository.changeInventoryQuantity(item, -99);
    item = (await repository.getInventoryItems()).single;
    expect(item.quantity, 0);

    await repository.addFoodStock(name: 'Rice', quantity: 2.5, unit: 'kg');
    var food = (await repository.getFoodStocks()).single;
    await repository.changeFoodQuantity(food, 1);
    food = (await repository.getFoodStocks()).single;
    expect(food.quantity, 3.5);
    await repository.changeFoodQuantity(food, -99);
    food = (await repository.getFoodStocks()).single;
    expect(food.quantity, 0);
  });

  test('repository updates and deletes task and log records', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);
    final repository = RoomkeeperRepository(database);

    final todoId = await repository.addTodoItem(
      title: 'Clean sink',
      notes: 'Old',
      dueAt: DateTime(2026, 6, 18),
      reminderAt: DateTime(2026, 6, 19),
    );
    await repository.updateTodoItem(
      id: todoId,
      title: 'Clean shelf',
      notes: 'Updated',
      dueAt: DateTime(2026, 6, 20),
    );

    final todo = (await repository.getTodoItems()).single;
    expect(todo.title, 'Clean shelf');
    expect(todo.notes, 'Updated');
    expect(todo.dueAt, DateTime(2026, 6, 20));
    expect(todo.reminderAt, isNull);

    final laundryId = await repository.addLaundryLog(
      completedAt: DateTime(2026, 6, 1),
      nextReminderAt: DateTime(2026, 6, 8),
      notes: 'Sheets',
    );
    await repository.updateLaundryLog(
      id: laundryId,
      completedAt: DateTime(2026, 6, 2),
      notes: 'Towels',
    );
    var laundry = await repository.getLaundryLogs();
    expect(laundry.single.completedAt, DateTime(2026, 6, 2));
    expect(laundry.single.notes, 'Towels');
    expect(laundry.single.nextReminderAt, isNull);
    await repository.deleteLaundryLog(laundryId);
    laundry = await repository.getLaundryLogs();
    expect(laundry, isEmpty);

    final paymentId = await repository.addPaymentLog(
      billType: 'rent',
      billingMonth: '2026-06',
      paidAt: DateTime(2026, 6, 3),
      amountCents: 120000,
      nextReminderAt: DateTime(2026, 7, 1),
      notes: 'June',
    );
    await repository.updatePaymentLog(
      id: paymentId,
      billType: 'water',
      billingMonth: '2026-07',
      paidAt: DateTime(2026, 7, 3),
      amountCents: 50000,
      notes: 'Updated',
    );
    var payments = await repository.getPaymentLogs();
    expect(payments.single.billType, 'water');
    expect(payments.single.billingMonth, '2026-07');
    expect(payments.single.amountCents, 50000);
    expect(payments.single.nextReminderAt, isNull);
    await repository.deletePaymentLog(paymentId);
    payments = await repository.getPaymentLogs();
    expect(payments, isEmpty);
  });

  test('repository manages laundry basket counters', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);
    final repository = RoomkeeperRepository(database);

    await repository.ensureLaundryBasketDefaults();
    var items = await repository.getLaundryBasketItems();
    expect(items.map((item) => item.name), [
      'Shirt',
      'Underwear',
      'Shorts',
      'Pants',
    ]);

    await repository.changeLaundryBasketCount(items.first, 1);
    await repository.changeLaundryBasketCount(
      (await repository.getLaundryBasketItems()).first,
      -5,
    );
    items = await repository.getLaundryBasketItems();
    expect(items.first.count, 0);

    await repository.changeLaundryBasketCount(items.first, 3);
    await repository.addLaundryBasketItem('Hanky');
    items = await repository.getLaundryBasketItems();
    expect(items.map((item) => item.name), contains('Hanky'));
    expect(items.first.count, 3);

    await repository.resetLaundryBasketCounts();
    items = await repository.getLaundryBasketItems();
    expect(items.every((item) => item.count == 0), isTrue);
  });

  test(
    'repository persists contiguous layout cells and rejects islands',
    () async {
      final database = inMemoryDatabaseForTests();
      addTearDown(database.close);
      final repository = RoomkeeperRepository(database);

      await repository.ensureDefaults();
      final layout = await repository.getPrimaryLayout();
      final bed = (await repository.getLayoutObjects(
        layout!.id,
      )).firstWhere((object) => object.label == 'Bed');

      await repository.replaceLayoutObjectCells(
        object: bed,
        cells: {(column: 1, row: 1), (column: 2, row: 1), (column: 2, row: 2)},
      );

      final cells = await repository.getLayoutCells(layout.id);
      expect(cells, hasLength(3));
      expect(cells.map((cell) => cell.layoutObjectId).toSet(), {bed.id});

      await expectLater(
        repository.replaceLayoutObjectCells(
          object: bed,
          cells: {(column: 1, row: 1), (column: 5, row: 5)},
        ),
        throwsArgumentError,
      );
    },
  );

  test('deleting room item removes managed stored photo file', () async {
    final database = inMemoryDatabaseForTests();
    addTearDown(database.close);
    final repository = RoomkeeperRepository(database);
    final temp = await Directory.systemTemp.createTemp(
      'roomkeeper_managed_photo_test',
    );
    addTearDown(() => temp.delete(recursive: true));
    final photoDir = Directory('${temp.path}/inventory_photos');
    await photoDir.create();
    final photo = File('${photoDir.path}/item.jpg');
    await photo.writeAsBytes([1, 2, 3]);

    await repository.ensureDefaults();
    final id = await repository.addInventoryItem(
      name: 'Lamp',
      photoPath: photo.path,
    );

    await repository.deleteInventoryItem(id);

    expect(await photo.exists(), isFalse);
    expect(await repository.getInventoryItems(), isEmpty);
  });

  test(
    'deleting room item keeps unrelated or missing photo paths safe',
    () async {
      final database = inMemoryDatabaseForTests();
      addTearDown(database.close);
      final repository = RoomkeeperRepository(database);
      final temp = await Directory.systemTemp.createTemp(
        'roomkeeper_unmanaged_photo_test',
      );
      addTearDown(() => temp.delete(recursive: true));
      final galleryPhoto = File('${temp.path}/gallery-original.jpg');
      await galleryPhoto.writeAsBytes([1, 2, 3]);

      await repository.ensureDefaults();
      final galleryItem = await repository.addInventoryItem(
        name: 'Gallery item',
        photoPath: galleryPhoto.path,
      );
      final missingItem = await repository.addInventoryItem(
        name: 'Missing item',
        photoPath: '${temp.path}/inventory_photos/missing.jpg',
      );

      await repository.deleteInventoryItem(galleryItem);
      await repository.deleteInventoryItem(missingItem);

      expect(await galleryPhoto.exists(), isTrue);
      expect(await repository.getInventoryItems(), isEmpty);
    },
  );
}
