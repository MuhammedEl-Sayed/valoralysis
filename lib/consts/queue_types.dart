// ignore: constant_identifier_names
enum QueueTypes { COMPETITIVE, UNRATED, DEATHMATCH, TEAM_DEATHMATCH }

class QueueTypesHelper {
  static String getValue(QueueTypes queueType) {
    switch (queueType) {
      case QueueTypes.COMPETITIVE:
        return 'competitive';
      case QueueTypes.UNRATED:
        return 'unrated';
      case QueueTypes.DEATHMATCH:
        return 'deathmatch';
      case QueueTypes.TEAM_DEATHMATCH:
        return 'team deathmatch';
    }
  }
}
