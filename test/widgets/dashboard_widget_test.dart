import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
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
    expect(find.text('Today at home'), findsOneWidget);
    expect(find.text('Upcoming reminders'), findsOneWidget);
    expect(find.text('Food to check'), findsOneWidget);
  });

  testWidgets('dashboard shows food needing multiple attention statuses once', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    final now = DateTime.now();
    final food = FoodStock(
      id: 1,
      name: 'Eggs',
      areaId: null,
      category: 'Fridge',
      quantity: 2,
      unit: 'pcs',
      expiryDate: now.add(const Duration(days: 2)),
      lowStockThreshold: 6,
      notes: null,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inventoryProvider.overrideWithValue(
            const AsyncValue.data(<InventoryItem>[]),
          ),
          foodProvider.overrideWithValue(AsyncValue.data([food])),
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

    expect(find.text('Eggs'), findsOneWidget);
    expect(find.textContaining('Expires'), findsOneWidget);
    expect(find.textContaining('2 pcs left'), findsOneWidget);
  });
}
