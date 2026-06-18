import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomkeeper/src/app.dart';

void main() {
  testWidgets('shell navigation shows only simplified destinations', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RoomKeeperShell(location: '/', child: SizedBox.shrink()),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Laundry'), findsOneWidget);
    expect(find.text('Bills'), findsOneWidget);
    expect(find.text('Tasks'), findsNothing);
    expect(find.text('Layout'), findsNothing);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
  });
}
