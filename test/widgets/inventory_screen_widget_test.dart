import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomkeeper/src/data/database.dart';
import 'package:roomkeeper/src/features/inventory/inventory_screen.dart';
import 'package:roomkeeper/src/providers.dart';

void main() {
  testWidgets('add item dialog fits a narrow viewport without overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const kitchen = Area(
      id: 1,
      name: 'Kitchen with a longer display name',
      type: 'kitchen',
      colorHex: '#F97316',
      sortOrder: 0,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          areasProvider.overrideWithValue(const AsyncValue.data([kitchen])),
          inventoryProvider.overrideWithValue(
            const AsyncValue.data(<InventoryItem>[]),
          ),
        ],
        child: const MaterialApp(home: InventoryScreen()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Item'));
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
