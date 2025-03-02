class TextHelper {
  static String textLimit(String text, int limit) {
    if (text.length > limit) {
      return "${text.substring(0, limit)}...";
    }
    return text;
  }
}
