import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roomkeeper/src/data/database.dart';
import 'package:roomkeeper/src/features/home/home_screen.dart';
import 'package:roomkeeper/src/providers.dart';

void main() {
  testWidgets('dashboard renders local room status', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inventoryProvider.overrideWithValue(
            const AsyncValue.data(<InventoryItem>[]),
          ),
          foodProvider.overrideWithValue(const AsyncValue.data(<FoodStock>[])),
          activeRemindersProvider.overrideWithValue(
            const AsyncValue.data(<Reminder>[]),
          ),
          todosProvider.overrideWithValue(const AsyncValue.data(<TodoItem>[])),
          laundryProvider.overrideWithValue(
            const AsyncValue.data(<LaundryLog>[]),
          ),
          paymentsProvider.overrideWithValue(
            const AsyncValue.data(<PaymentLog>[]),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('RoomKeeper'), findsOneWidget);
    expect(find.text('Room check'), findsOneWidget);
    expect(find.text('Upcoming reminders'), findsOneWidget);
    expect(find.text('Food attention'), findsOneWidget);
  });
}
