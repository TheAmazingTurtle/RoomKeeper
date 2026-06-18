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

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
