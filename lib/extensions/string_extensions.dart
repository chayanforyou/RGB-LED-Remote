extension StringExtensions on String {

  String formatName() {
    return replaceAll('_', ' ').capitalize();
  }

  String capitalize() {
    return this
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
        .join(' ');
  }
}