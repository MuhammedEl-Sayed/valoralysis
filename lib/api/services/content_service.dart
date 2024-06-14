import 'dart:io';

import 'package:dio/dio.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/utils/image_cache_utils.dart';

class ContentService {
  static Future<Content> fetchContent() async {
    try {
      // Fetch all content in parallel
      final results = await Future.wait([
        fetchAgents(),
        fetchRanks(),
        fetchWeapons(),
        fetchContentData('https://valorant-api.com/v1/maps'),
        fetchContentData('https://valorant-api.com/v1/gamemodes'),
        fetchContentData('https://valorant-api.com/v1/seasons'),
      ]);

      return Content(
        agents: results[0],
        ranks: results[1],
        weapons: results[2],
        maps: results[3],
        gameModes: results[4],
        acts: results[5],
      );
    } catch (e) {
      print('Error fetching content: $e');
      rethrow;
    }
  }

  static Future<List<ContentItem>> fetchAgents() async {
    Dio dio = Dio();

    try {
      var response = await dio.get('https://valorant-api.com/v1/agents');
      List<ContentItem> contentItems = [];
      List<String> urls = [];
      List<String> ids = [];
      List<Map<String, String>> abilityUrls = [];

      for (var item in response.data['data']) {
        if (item['uuid'] == null || item['displayIcon'] == null) {
          continue;
        }
        String uuid = item['uuid'];
        String imageUrl = item['displayIcon'];
        //get abilities displayIcon, in array under abilities under displayIcon
        // Ability1, Ability2, Grenade, Ultimate.
        Map<String, String> abilityMap = {};
        for (var ability in item['abilities']) {
          if (ability['displayIcon'] != null) {
            abilityMap[ability['slot']] = ability['displayIcon'];
          }
        }
        abilityUrls.add(abilityMap);
        ids.add(uuid);
        urls.add(imageUrl);
      }
      print('map: $abilityUrls');

      List<File?> images = await ImageCacheUtils.downloadImageFiles(urls, ids);
      try {
        for (var i = 0; i < images.length; i++) {
          if (images[i] != null) {
            String hash = ImageCacheUtils.generateImageHash(images[i]!);

            List<File?> abilityImages =
                await ImageCacheUtils.downloadAbilityFiles(
                    abilityUrls[i], response.data['data'][i]['uuid']);
            contentItems.add(ContentItem.fromJsonAgents(
                response.data['data'][i], hash,
                iconUrl: images[i]!.path,
                abilities: abilityImages.map((e) => e!.path).toList()));
          }
        }
        return contentItems;
      } catch (e) {
        print('Error fetching ability images: $e');
      }
      return [];
    } catch (e) {
      print('Error fetching agents: $e');
      return [];
    }
  }

  static Future<List<ContentItem>> fetchRanks() async {
    Dio dio = Dio();
    try {
      var response =
          await dio.get('https://valorant-api.com/v1/competitivetiers');
      List<ContentItem> ranks = [];
      List<String> urls = [];
      List<String> ids = [];
      var lastDataObject = response.data['data'].last;

      for (var tier in lastDataObject['tiers']) {
        String id = tier['tier'].toString();
        String url = tier['smallIcon'] ?? '';
        ids.add(id);
        urls.add(url);
      }

      List<File?> images = await ImageCacheUtils.downloadImageFiles(urls, ids);

      for (var i = 0; i < images.length; i++) {
        if (images[i] != null && urls[i] != '') {
          String hash = ImageCacheUtils.generateImageHash(images[i]!);
          ranks.add(ContentItem.fromJsonRanks(lastDataObject['tiers'][i], hash,
              iconUrl: images[i]!.path));
        }
      }
      return ranks;
    } catch (e) {
      print('Error fetching ranks: $e');
      return [];
    }
  }

  static Future<List<ContentItem>> fetchWeapons() async {
    Dio dio = Dio();
    try {
      var response = await dio.get('https://valorant-api.com/v1/weapons');
      List<ContentItem> contentItems = [];
      List<String> iconUrls = [];
      List<String> silhouetteUrl = [];
      List<String> ids = [];
      for (var item in response.data['data']) {
        if (item['uuid'] == null || item['displayIcon'] == null) {
          continue;
        }
        String uuid = item['uuid'];
        String imageUrl = item['displayIcon'];
        String silhoutteUrl = item['killStreamIcon'];
        ids.add(uuid);
        iconUrls.add(imageUrl);
        silhouetteUrl.add(silhoutteUrl);
      }
      Future.wait([
        ImageCacheUtils.downloadImageFiles(iconUrls, ids),
        ImageCacheUtils.downloadImageFiles(
            silhouetteUrl, ids.map((id) => '${id}_silhouette').toList())
      ]).then((results) {
        List<File?> iconImages = results[0];
        List<File?> silhouetteImages = results[1];
        for (var i = 0; i < iconImages.length; i++) {
          if (silhouetteImages[i] != null && iconImages[i] != null) {
            String hash = ImageCacheUtils.generateImageHash(iconImages[i]!);
            contentItems.add(ContentItem.fromJsonWeapon(
                response.data['data'][i], hash,
                iconUrl: iconImages[i]!.path,
                silhouetteUrl: silhouetteImages[i]!.path));
          }
        }
        return contentItems;
      });
      return contentItems;
    } catch (e) {
      print('Error fetching weapons: $e');
      return [];
    }
  }

  static Future<List<ContentItem>> fetchContentData(String url) async {
    Dio dio = Dio();
    String type = url.split('/').last;
    bool isMap = type == 'maps';

    try {
      var response = await dio.get(url);
      List<ContentItem> contentItems = [];
      List<String> urls = [];
      List<String> ids = [];
      for (var item in response.data['data']) {
        if (item['uuid'] == null || item['displayIcon'] == null) {
          continue;
        }
        String uuid = item['uuid'];
        String imageUrl = item['displayIcon'];
        ids.add(uuid);
        urls.add(imageUrl);
      }
      List<File?> images = await ImageCacheUtils.downloadImageFiles(urls, ids);
      for (var i = 0; i < images.length; i++) {
        if (images[i] != null) {
          String hash = ImageCacheUtils.generateImageHash(images[i]!);
          if (isMap) {
            contentItems.add(ContentItem.fromJsonMap(
                response.data['data'][i], hash,
                iconUrl: images[i]!.path));
          } else {
            contentItems.add(ContentItem.fromJson(
                response.data['data'][i], hash,
                iconUrl: images[i]!.path));
          }
        }
      }
      return contentItems;
    } catch (e) {
      print('Error fetching $type: $e');
      return [];
    }
  }

  static Future<File?> downloadImage(String url, String id) async {
    File? image = await ImageCacheUtils.downloadImageFile(url, id);
    return image;
  }
}
