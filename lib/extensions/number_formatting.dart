import 'package:intl/intl.dart';

extension NumberFormatting on num {
  String get withThousandSeparator => NumberFormat('#,##0.00').format(this);
}
