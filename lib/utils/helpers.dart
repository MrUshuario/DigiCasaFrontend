import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';


class Helpers {

  static Future<String> readData(String? path) async {
    return await rootBundle.loadString(path!);
  }

  static String formatDate(String format, DateTime dateTime) {
    return DateFormat(format).format(dateTime).toString();
  }
}