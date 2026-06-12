import 'package:intl/intl.dart';

final DateFormat shortDateFormat = DateFormat.yMMMd('en_PH');
final DateFormat dateTimeFormat = DateFormat.yMMMd('en_PH').add_jm();
final DateFormat monthFormat = DateFormat('yyyy-MM', 'en_PH');
final NumberFormat pesoFormat = NumberFormat.currency(
  locale: 'en_PH',
  symbol: 'PHP ',
);

String formatDate(DateTime? value) {
  if (value == null) {
    return 'No date';
  }
  return shortDateFormat.format(value);
}

String formatDateTime(DateTime? value) {
  if (value == null) {
    return 'No reminder';
  }
  return dateTimeFormat.format(value);
}

String formatPesoCents(int cents) {
  return pesoFormat.format(cents / 100);
}

int parsePesoToCents(String value) {
  final normalized = value.replaceAll(',', '').trim();
  final parsed = double.tryParse(normalized);
  return ((parsed ?? 0) * 100).round();
}

String compactQuantity(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}
