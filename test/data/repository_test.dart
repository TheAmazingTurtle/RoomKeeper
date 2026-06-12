import 'package:flutter_test/flutter_test.dart';
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
}
