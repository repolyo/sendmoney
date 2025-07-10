import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String format([String pattern = 'yMMMd']) => DateFormat(pattern).format(this);
  String get dateString => DateFormat('MMMM d, y').format(this);
}
