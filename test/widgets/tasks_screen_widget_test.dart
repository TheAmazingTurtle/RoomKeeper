import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:roomkeeper/src/data/database.dart';
import 'package:roomkeeper/src/features/tasks/tasks_screen.dart';
import 'package:roomkeeper/src/providers.dart';

void main() {
  testWidgets('to-do dialog handles due date and reminder date time', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todosProvider.overrideWithValue(const AsyncValue.data(<TodoItem>[])),
          laundryProvider.overrideWithValue(
            const AsyncValue.data(<LaundryLog>[]),
          ),
          paymentsProvider.overrideWithValue(
            const AsyncValue.data(<PaymentLog>[]),
          ),
        ],
        child: const MaterialApp(home: TasksScreen()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Add to-do'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).first, 'Clean sink');

    await tester.tap(find.text('Due date'));
    await tester.pump();
    await tester.tap(find.text('OK'));
    await tester.pump();

    await tester.tap(find.text('Reminder'));
    await tester.pump();
    await tester.tap(find.text('OK'));
    await tester.pump();
    await tester.tap(find.text('OK'));
    await tester.pump();

    expect(find.text('No date'), findsNothing);
    expect(find.text('No reminder'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('laundry log dialog opens and cancels without date crash', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todosProvider.overrideWithValue(const AsyncValue.data(<TodoItem>[])),
          laundryProvider.overrideWithValue(
            const AsyncValue.data(<LaundryLog>[]),
          ),
          paymentsProvider.overrideWithValue(
            const AsyncValue.data(<PaymentLog>[]),
          ),
        ],
        child: const MaterialApp(home: TasksScreen()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Laundry'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log laundry'));
    await tester.pump();

    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Next reminder'), findsOneWidget);
    expect(find.text('No reminder'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('payment log dialog opens and validates without date crash', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todosProvider.overrideWithValue(const AsyncValue.data(<TodoItem>[])),
          laundryProvider.overrideWithValue(
            const AsyncValue.data(<LaundryLog>[]),
          ),
          paymentsProvider.overrideWithValue(
            const AsyncValue.data(<PaymentLog>[]),
          ),
        ],
        child: const MaterialApp(home: TasksScreen()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Bills'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log payment'));
    await tester.pump();

    expect(find.text('Billing month'), findsOneWidget);
    expect(find.text('Paid date'), findsOneWidget);
    expect(find.text('Next reminder'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Enter a positive amount'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '0');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Enter a positive amount'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '-10');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Enter a positive amount'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('task and log rows expose edit and delete actions', (
    tester,
  ) async {
    await initializeDateFormatting('en_PH');
    await tester.binding.setSurfaceSize(const Size(900, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final now = DateTime.now();
    final todo = TodoItem(
      id: 1,
      title: 'Clean sink',
      notes: 'Use vinegar',
      isDone: false,
      dueAt: now,
      reminderAt: now.add(const Duration(days: 1)),
      createdAt: now,
      updatedAt: now,
    );
    final laundry = LaundryLog(
      id: 2,
      completedAt: now,
      notes: 'Sheets',
      nextReminderAt: now.add(const Duration(days: 7)),
    );
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
          todosProvider.overrideWithValue(AsyncValue.data([todo])),
          laundryProvider.overrideWithValue(AsyncValue.data([laundry])),
          paymentsProvider.overrideWithValue(AsyncValue.data([payment])),
        ],
        child: const MaterialApp(home: TasksScreen()),
      ),
    );
    await tester.pump();

    expect(find.byTooltip('Edit task'), findsOneWidget);
    expect(find.byTooltip('Delete task'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete task'));
    await tester.pump();
    expect(find.text('Delete to-do?'), findsOneWidget);
    expect(
      find.text('Delete "Clean sink"? This cannot be undone.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pump();

    await tester.tap(find.byTooltip('Edit task'));
    await tester.pump();
    expect(find.text('Edit to-do'), findsOneWidget);
    expect(find.text('Clean sink'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Laundry'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Edit laundry log'), findsOneWidget);
    expect(find.byTooltip('Delete laundry log'), findsOneWidget);

    await tester.tap(find.text('Bills'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Edit payment log'), findsOneWidget);
    expect(find.byTooltip('Delete payment log'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit payment log'));
    await tester.pump();
    expect(find.text('Edit payment log'), findsOneWidget);
    expect(find.text('1200.00'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
