import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
final _dateTime = DateFormat('EEE, dd MMM yyyy • hh:mm a');
final _dateOnly = DateFormat('dd MMM yyyy');

String formatCurrency(double value) => _currency.format(value);
String formatDateTime(DateTime dt) => _dateTime.format(dt);
String formatDate(DateTime dt) => _dateOnly.format(dt);
