class MyLibString {
  static String removePunctuation(String text) {
    text = text.replaceAll(RegExp(r'[.,!?;]'), '');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text;
  }
}
