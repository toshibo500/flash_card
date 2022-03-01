import 'package:intl/intl.dart';

class DateTimeUtil {
  // toLocale
  static String toLocaleString(DateTime? dateTime, String format) {
    if (dateTime == null) {
      return '';
    }
    DateFormat outputFormat = DateFormat(format);
    return outputFormat.format(dateTime.toLocal());
  }
}
