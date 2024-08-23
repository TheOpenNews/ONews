import 'package:intl/intl.dart';

class DDateFormat {
  static final DefaultDF = DateFormat("dd/MM/yyyy");
  static String parseDate(String date) {
    try {
      return DDateFormat.DefaultDF.format(DateTime.parse(date));
    } catch (e) {
      return date;
    }
  }
}
