import 'package:valoralysis/models/content.dart';

class ContentUtils {
  static bool isContentOld(Content newContent, Content oldContent) {
    if (newContent.agents.length != oldContent.agents.length) {
      print(
          "Agents length mismatch in new content: ${newContent.agents.length} and old content: ${oldContent.agents.length}");
      return true;
    }
    if (newContent.maps.length != oldContent.maps.length) {
      print("Maps length mismatch");
      return true;
    }
    if (newContent.gameModes.length != oldContent.gameModes.length) {
      print("Game modes length mismatch");
      return true;
    }
    if (newContent.acts.length != oldContent.acts.length) {
      print("Acts length mismatch");
      return true;
    }
    if (newContent.weapons.length != oldContent.weapons.length) {
      print("Weapons length mismatch");
      return true;
    }
    if (newContent.ranks.length != oldContent.ranks.length) {
      print("Ranks length mismatch");
      return true;
    }

    if (!areContentItemsEqual(newContent.maps, oldContent.maps)) {
      print("Maps content mismatch");
      return true;
    }
    if (!areContentItemsEqual(newContent.agents, oldContent.agents)) {
      print("Agents content mismatch");
      return true;
    }
    if (!areContentItemsEqual(newContent.gameModes, oldContent.gameModes)) {
      print("Game modes content mismatch");
      return true;
    }
    if (!areContentItemsEqual(newContent.acts, oldContent.acts)) {
      print("Acts content mismatch");
      return true;
    }
    if (!areContentItemsEqual(newContent.weapons, oldContent.weapons)) {
      print("Weapons content mismatch");
      return true;
    }
    if (!areContentItemsEqual(newContent.ranks, oldContent.ranks)) {
      print("Ranks content mismatch");
      return true;
    }

    return false;
  }

  static bool areContentItemsEqual(
      List<ContentItem> newItems, List<ContentItem> oldItems) {
    for (var i = 0; i < newItems.length; i++) {
      if (newItems[i].hash != oldItems[i].hash) {
        print("Content item hash mismatch at index $i");
        return false;
      }
    }
    return true;
  }
}
