import 'package:intl/intl.dart';
import 'package:valoralysis/utils/history_utils.dart';

class TimeUtils {
  static String timeAgo(int date) {
    final Duration diff =
        DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(date));

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} seconds ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 30) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} months ago';
    } else {
      return '${(diff.inDays / 365).floor()} years ago';
    }
  }

  static Map<String, dynamic> buildMatchesByDayMap(
      List<Map<String, dynamic>> matchDetails) {
    Map<String, dynamic> matchesByDay = {};

    for (Map<String, dynamic> matchDetail in matchDetails) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          HistoryUtils.extractStartTime(matchDetail));
      int daysSince = DateTime.now().difference(date).inDays;

      String key;
      if (daysSince == 0) {
        key = 'Today';
      } else if (daysSince == 1) {
        key = 'Yesterday';
      } else if (daysSince < 7) {
        key = '$daysSince days ago';
      } else {
        key = DateFormat.yMd().format(date);
      }

      if (!matchesByDay.keys.contains(key)) {
        matchesByDay[key] = [];
      }
      matchesByDay[key].add(matchDetail);
    }
    return matchesByDay;
  }
}
