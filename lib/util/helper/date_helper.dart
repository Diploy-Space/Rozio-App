import 'package:intl/intl.dart';

class DateHelper {
  static String apiDate(DateTime date) {
    // Backend endpoint expects day-month-year (e.g. 17-5-2026).
    return DateFormat('d-M-yyyy').format(date);
  }

  static String weekday(DateTime date) {
    return DateFormat('EEEE').format(date).toLowerCase();
  }
}
