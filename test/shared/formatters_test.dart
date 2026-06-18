import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:roomkeeper/src/shared/formatters.dart';

void main() {
  test('formats en_PH dates after locale data is initialized', () async {
    await initializeDateFormatting('en_PH');

    expect(formatDate(DateTime(2026, 6, 18)), contains('2026'));
    expect(formatDateTime(DateTime(2026, 6, 18, 9, 30)), contains('2026'));
  });
}
