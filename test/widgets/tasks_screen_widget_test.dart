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
}
