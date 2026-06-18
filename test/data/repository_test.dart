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
