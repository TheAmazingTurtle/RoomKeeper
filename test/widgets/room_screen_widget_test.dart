import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomkeeper/src/data/database.dart';
import 'package:roomkeeper/src/features/room/room_screen.dart';
import 'package:roomkeeper/src/providers.dart';

void main() {
  testWidgets('room layout exposes room area guidance and edit controls', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final layout = RoomLayout(
      id: 1,
      name: 'My Room',
      width: 360,
      height: 520,
      gridSize: 20,
      updatedAt: DateTime(2026),
    );
    const bedArea = Area(
      id: 1,
      name: 'Bed',
      type: 'bed',
      colorHex: '#10B981',
      sortOrder: 0,
    );
    const bedObject = LayoutObject(
      id: 1,
      layoutId: 1,
      linkedAreaId: 1,
      label: 'Bed',
      kind: 'furniture',
      x: 32,
      y: 320,
      width: 180,
      height: 150,
      rotation: 0,
      colorHex: '#10B981',
      zOrder: 1,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          primaryLayoutProvider.overrideWithValue(AsyncValue.data(layout)),
          areasProvider.overrideWithValue(const AsyncValue.data([bedArea])),
          inventoryProvider.overrideWithValue(const AsyncValue.data([])),
          layoutObjectsProvider(
            layout.id,
          ).overrideWithValue(const AsyncValue.data([bedObject])),
        ],
        child: const MaterialApp(home: RoomScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Room area'), findsOneWidget);
    expect(
      find.textContaining('Tap a room area to configure it'),
      findsOneWidget,
    );

    await tester.tap(find.text('Bed').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Selected'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Room area label'), findsOneWidget);
    expect(find.text('Type'), findsOneWidget);
    expect(find.text('Linked area'), findsOneWidget);
    expect(find.text('Apply details'), findsOneWidget);
    expect(find.text('Position and size'), findsOneWidget);
    expect(find.text('Rotation'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete room area'));
    await tester.pump();

    expect(find.text('Delete room area?'), findsOneWidget);
    expect(find.text('Delete "Bed"? This cannot be undone.'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('add room area dialog handles interactions and cancel safely', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final layout = RoomLayout(
      id: 1,
      name: 'My Room',
      width: 360,
      height: 520,
      gridSize: 20,
      updatedAt: DateTime(2026),
    );
    const kitchenArea = Area(
      id: 1,
      name: 'Kitchen',
      type: 'kitchen',
      colorHex: '#F97316',
      sortOrder: 0,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          primaryLayoutProvider.overrideWithValue(AsyncValue.data(layout)),
          areasProvider.overrideWithValue(const AsyncValue.data([kitchenArea])),
          inventoryProvider.overrideWithValue(const AsyncValue.data([])),
          layoutObjectsProvider(
            layout.id,
          ).overrideWithValue(const AsyncValue.data([])),
        ],
        child: const MaterialApp(home: RoomScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('Room area').first);
    await tester.pump();
    expect(find.text('Add room area'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Window nook');
    await tester.tap(find.text('Zone'));
    await tester.pump();
    await tester.tap(find.text('Storage').last);
    await tester.pump();

    await tester.tap(find.text('None'));
    await tester.pump();
    await tester.tap(find.text('Kitchen').last);
    await tester.pump();

    await tester.tap(find.byTooltip('Use color #F97316'));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Add room area'), findsNothing);
  });

  testWidgets('selected room area shows linked item overflow and full list', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final layout = RoomLayout(
      id: 1,
      name: 'My Room',
      width: 360,
      height: 520,
      gridSize: 20,
      updatedAt: DateTime(2026),
    );
    const bedArea = Area(
      id: 1,
      name: 'Bed',
      type: 'bed',
      colorHex: '#10B981',
      sortOrder: 0,
    );
    const bedObject = LayoutObject(
      id: 1,
      layoutId: 1,
      linkedAreaId: 1,
      label: 'Bed',
      kind: 'furniture',
      x: 32,
      y: 320,
      width: 180,
      height: 150,
      rotation: 0,
      colorHex: '#10B981',
      zOrder: 1,
    );
    final now = DateTime(2026);
    final items = List.generate(
      8,
      (index) => InventoryItem(
        id: index + 1,
        name: 'Bed item ${index + 1}',
        areaId: bedArea.id,
        quantity: index + 1,
        condition: 'Good',
        notes: null,
        photoPath: null,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          primaryLayoutProvider.overrideWithValue(AsyncValue.data(layout)),
          areasProvider.overrideWithValue(const AsyncValue.data([bedArea])),
          inventoryProvider.overrideWithValue(AsyncValue.data(items)),
          layoutObjectsProvider(
            layout.id,
          ).overrideWithValue(const AsyncValue.data([bedObject])),
        ],
        child: const MaterialApp(home: RoomScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('Bed').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('8 items'), findsOneWidget);
    expect(find.text('+2 more linked'), findsOneWidget);
    expect(find.text('Bed item 7'), findsNothing);

    await tester.ensureVisible(find.text('View all'));
    await tester.pump();
    await tester.tap(find.text('View all'));
    await tester.pump();

    expect(find.text('Linked items for Bed'), findsOneWidget);
    expect(find.text('Bed item 7'), findsOneWidget);
    expect(find.text('Bed item 8'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
