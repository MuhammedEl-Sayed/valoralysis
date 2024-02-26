import 'package:valoralysis/models/match_history.dart';

class HistoryUtils {
  static String extractMatchID(MatchHistory matchHistory) {
    return matchHistory.MatchID;
  }

  static List<String> extractMatchIDs(List<MatchHistory> matchHistories) {
    return matchHistories
        .map((matchHistory) => extractMatchID(matchHistory))
        .toList();
  }
}
