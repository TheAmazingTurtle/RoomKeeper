import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:roomkeeper/src/data/database.dart';
import 'package:roomkeeper/src/features/laundry_bills/laundry_bills_screens.dart';
import 'package:roomkeeper/src/providers.dart';

void main() {
  testWidgets('laundry page shows basket counters and add item dialog', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final now = DateTime.now();
    final laundry = LaundryBasketItem(
      id: 2,
      name: 'Shirt',
      count: 2,
      isDefault: true,
      sortOrder: 0,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          laundryBasketProvider.overrideWithValue(AsyncValue.data([laundry])),
        ],
        child: const MaterialApp(home: LaundryScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Laundry'), findsOneWidget);
    expect(find.text('Shirt'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.byTooltip('Add one Shirt'), findsOneWidget);
    expect(find.byTooltip('Remove one Shirt'), findsOneWidget);
    expect(find.byTooltip('Reset basket'), findsOneWidget);

    await tester.tap(find.text('Add item'));
    await tester.pump();
    expect(find.text('Add laundry item'), findsOneWidget);
    expect(find.text('Item type'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('bills page opens payment dialog and validates amount', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final now = DateTime.now();
    final payment = PaymentLog(
      id: 3,
      billType: 'rent',
      billingMonth: '2026-06',
      paidAt: now,
      amountCents: 120000,
      notes: 'June',
      nextReminderAt: now.add(const Duration(days: 30)),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paymentsProvider.overrideWithValue(AsyncValue.data([payment])),
        ],
        child: const MaterialApp(home: BillsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Bills'), findsOneWidget);
    expect(find.byTooltip('Edit payment log'), findsOneWidget);
    expect(find.byTooltip('Delete payment log'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit payment log'));
    await tester.pump();
    expect(find.text('Edit payment'), findsOneWidget);
    expect(find.text('1200.00'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add payment'));
    await tester.pump();
    expect(find.text('Billing month'), findsOneWidget);
    expect(find.text('Paid date'), findsOneWidget);
    expect(find.text('Next reminder'), findsOneWidget);

    await tester.tap(find.text('Save payment'));
    await tester.pump();
    expect(find.text('Enter a positive amount'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
