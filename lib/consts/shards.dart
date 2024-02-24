// ignore: constant_identifier_names
enum Shards { NA, EU, AP, KR }

class ShardsHelper {
  static String getValue(Shards shard) {
    switch (shard) {
      case Shards.NA:
        return 'na';
      case Shards.EU:
        return 'eu';
      case Shards.AP:
        return 'ap';
      case Shards.KR:
        return 'kr';
    }
  }
}
