class FormattingUtils {
  static String capitalizeFirstLetter(String str) {
    return '${str[0]}${str.substring(1, str.length).toLowerCase()}';
  }
}
