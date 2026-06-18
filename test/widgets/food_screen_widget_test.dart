import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:roomkeeper/src/data/database.dart';
import 'package:roomkeeper/src/features/food/food_screen.dart';
import 'package:roomkeeper/src/providers.dart';

void main() {
  testWidgets('food dialog validates invalid low stock threshold', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          areasProvider.overrideWithValue(const AsyncValue.data(<Area>[])),
          foodProvider.overrideWithValue(const AsyncValue.data(<FoodStock>[])),
        ],
        child: const MaterialApp(home: FoodScreen()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Add food'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(0), 'Rice');
    await tester.enterText(find.byType(TextFormField).at(4), 'abc');
    await tester.tap(find.text('Add food').last);
    await tester.pump();

    expect(find.text('Use a positive number or leave blank'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('food detail modal shows full long notes', (tester) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const longNote =
        'This food has a long storage note that should remain fully readable in the detail modal instead of only appearing in the truncated card summary.';
    final now = DateTime(2026);
    const kitchen = Area(
      id: 1,
      name: 'Kitchen',
      type: 'kitchen',
      colorHex: '#F97316',
      sortOrder: 0,
    );
    final food = FoodStock(
      id: 1,
      name: 'Eggs',
      areaId: kitchen.id,
      category: 'Fridge',
      quantity: 12,
      unit: 'pcs',
      expiryDate: DateTime(2026, 6, 25),
      lowStockThreshold: 6,
      notes: longNote,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          areasProvider.overrideWithValue(const AsyncValue.data([kitchen])),
          foodProvider.overrideWithValue(AsyncValue.data([food])),
        ],
        child: const MaterialApp(home: FoodScreen()),
      ),
    );
    await tester.pump();

    expect(find.byTooltip('Remove one Eggs'), findsOneWidget);
    expect(find.byTooltip('Add one Eggs'), findsOneWidget);

    await tester.tap(find.text('Eggs'));
    await tester.pump();

    expect(find.text('Notes'), findsOneWidget);
    expect(find.text(longNote), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('food delete asks for confirmation with food name', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final now = DateTime(2026);
    final food = FoodStock(
      id: 1,
      name: 'Eggs',
      areaId: null,
      category: 'Fridge',
      quantity: 12,
      unit: 'pcs',
      expiryDate: null,
      lowStockThreshold: null,
      notes: null,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          areasProvider.overrideWithValue(const AsyncValue.data(<Area>[])),
          foodProvider.overrideWithValue(AsyncValue.data([food])),
        ],
        child: const MaterialApp(home: FoodScreen()),
      ),
    );
    await tester.pump();

    await tester.drag(find.text('Eggs'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Delete food item?'), findsOneWidget);
    expect(
      find.text('Remove "Eggs" from RoomKeeper? This cannot be undone.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('expired food status does not crowd details on narrow width', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final now = DateTime.now();
    final food = FoodStock(
      id: 1,
      name: 'Emergency noodles',
      areaId: null,
      category: 'Pantry shelf',
      quantity: 1,
      unit: 'pack',
      expiryDate: now.subtract(const Duration(days: 1)),
      lowStockThreshold: 2,
      notes: 'Replace this week',
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          areasProvider.overrideWithValue(const AsyncValue.data(<Area>[])),
          foodProvider.overrideWithValue(AsyncValue.data([food])),
        ],
        child: const MaterialApp(home: FoodScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Emergency noodles'), findsOneWidget);
    expect(find.text('Expired'), findsOneWidget);
    expect(find.text('Low stock'), findsOneWidget);
    expect(find.textContaining('1 pack'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
