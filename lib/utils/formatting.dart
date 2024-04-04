import 'package:valoralysis/models/content.dart';

class FormattingUtils {
  static String capitalizeFirstLetter(String str) {
    return '${str[0]}${str.substring(1, str.length).toLowerCase()}';
  }

  static String convertContentIdToName(List<ContentItem> content, String id) {
    print(content.firstWhere((item) => item.id == id));
    return content.firstWhere((item) => item.id == id).name;
  }

  static String convertWeaponIdToName(List<WeaponItem> content, String id) {
    return content.firstWhere((item) => item.uuid == id).name;
  }
}
