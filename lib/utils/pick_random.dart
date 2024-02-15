import 'dart:math';

class HelperFunctions {
  static String pickRandom(List<String> list) {
    return list[Random().nextInt(list.length)];
  }
}
