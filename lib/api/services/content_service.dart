import 'dart:io';

import 'package:dio/dio.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/utils/image_cache_utils.dart';

class ContentService {
  static Future<Content> fetchContent() async {
    try {
      List<ContentItem> agents =
          await fetchContentData('https://valorant-api.com/v1/agents');
      List<ContentItem> ranks = await getRanks();
      List<ContentItem> weapons =
          await fetchContentData('https://valorant-api.com/v1/weapons');
      List<ContentItem> maps =
          await fetchContentData('https://valorant-api.com/v1/maps');
      List<ContentItem> gameModes =
          await fetchContentData('https://valorant-api.com/v1/gamemodes');
      List<ContentItem> acts =
          await fetchContentData('https://valorant-api.com/v1/seasons');
      return Content(
          agents: agents,
          ranks: ranks,
          weapons: weapons,
          maps: maps,
          gameModes: gameModes,
          acts: acts);
    } catch (e) {
      print('Error fetching content: $e');
      rethrow;
    }
  }

  static Future<List<ContentItem>> getRanks() async {
    Dio dio = Dio();
    try {
      var response =
          await dio.get('https://valorant-api.com/v1/competitivetiers');
      List<ContentItem> ranks = [];
      for (var data in response.data['data']) {
        for (var tier in data['tiers']) {
          if (tier['smallIcon'] != null) {
            String id = tier['tier'];
            String url = tier['smallIcon'];
            File? image = await downloadImage(url, id);
            if (image != null) {
              String hash = ImageCacheUtils.generateImageHash(image);
              ranks.add(
                  ContentItem.fromJsonRanks(tier, hash, iconUrl: image.path));
            }
          }
        }
      }
      return ranks;
    } catch (e) {
      print('Error fetching ranks: $e');
      return [];
    }
  }

  static Future<List<ContentItem>> fetchContentData(String url) async {
    Dio dio = Dio();
    String type = url.split('/').last;
    bool isWeapon = type == 'weapons';
    bool isMap = type == 'maps';

    try {
      var response = await dio.get(url);
      List<ContentItem> contentItems = [];
      for (var item in response.data['data']) {
        String uuid = item['uuid'];
        String imageUrl = item['displayIcon'];
        File? image = await downloadImage(imageUrl, uuid);
        if (image != null) {
          String hash = ImageCacheUtils.generateImageHash(image);
          if (isWeapon) {
            contentItems.add(
                ContentItem.fromJsonWeapon(item, hash, iconUrl: image.path));
          } else if (isMap) {
            contentItems
                .add(ContentItem.fromJsonMap(item, hash, iconUrl: image.path));
          } else {
            contentItems
                .add(ContentItem.fromJson(item, hash, iconUrl: image.path));
          }
        }
      }
      return contentItems;
    } catch (e) {
      return [];
    }
  }

  static Future<File?> downloadImage(String url, String id) async {
    File? image = await ImageCacheUtils.downloadImageFile(url, id);
    return image;
  }
}
