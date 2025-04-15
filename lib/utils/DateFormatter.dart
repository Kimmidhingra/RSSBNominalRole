import 'package:intl/intl.dart';

class DateFormatter {
  /// Formats a [DateTime] object into a readable string (e.g., "March 23, 2025").
  static String formatFullDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  /// Formats a [DateTime] object into a short date string (e.g., "23 Mar 2025").
  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM y').format(date);
  }

  /// Formats a [DateTime] object into a time string (e.g., "10:30 AM").
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Formats a [DateTime] object into a date-time string (e.g., "23 Mar 2025, 10:30 AM").
  static String formatDateTime(DateTime date) {
    return DateFormat('d MMM y, hh:mm a').format(date);
  }

  /// Formats a [DateTime] object into an ISO 8601 string (e.g., "2025-03-23T10:30:00.000Z").
  static String formatISO(DateTime date) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(date.toUtc());
  }

  /// Parses a date string into a [DateTime] object.
  static DateTime parseDate(String dateString, {String format = 'y-MM-dd'}) {
    return DateFormat(format).parse(dateString);
  }

  /// Gets the current date formatted as [formatFullDate].
  static String getTodayFormatted() {
    return formatFullDate(DateTime.now());
  }
}
