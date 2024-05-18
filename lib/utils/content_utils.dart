import 'package:valoralysis/models/content.dart';

class ContentUtils {
  static bool isContentOld(Content newContent, Content oldContent) {
    if (newContent.agents.length != oldContent.agents.length ||
        newContent.maps.length != oldContent.maps.length ||
        newContent.gameModes.length != oldContent.gameModes.length ||
        newContent.acts.length != oldContent.acts.length ||
        newContent.weapons.length != oldContent.weapons.length ||
        newContent.ranks.length != oldContent.ranks.length) {
      return true;
    }

    return !areContentItemsEqual(newContent.maps, oldContent.maps) ||
        !areContentItemsEqual(newContent.agents, oldContent.agents) ||
        !areContentItemsEqual(newContent.gameModes, oldContent.gameModes) ||
        !areContentItemsEqual(newContent.acts, oldContent.acts) ||
        !areContentItemsEqual(newContent.weapons, oldContent.weapons) ||
        !areContentItemsEqual(newContent.ranks, oldContent.ranks);
  }

  static bool areContentItemsEqual(
      List<ContentItem> newItems, List<ContentItem> oldItems) {
    for (var i = 0; i < newItems.length; i++) {
      if (newItems[i].hash != oldItems[i].hash) {
        return false;
      }
    }
    return true;
  }
}
