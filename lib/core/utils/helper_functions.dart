class HelperFunctions {

  HelperFunctions._();

  static String formatCount(int count) {
    if (count < 1000) return count.toString();
    final value = count / 1000;
    return '${value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1)}k';
  }
}