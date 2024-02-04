class DateFormatter {
  /// Formats a date string to a more human-readable format.
  ///
  /// The input date should be in the format 'YYYY-MM-DDTHH:mm:ssZ'.
  ///
  /// Returns a formatted date string in the format 'DD/MM/YYYY'.
  static String formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
