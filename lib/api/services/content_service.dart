import 'dart:io';

import 'package:dio/dio.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/utils/image_cache_utils.dart';

class ContentService {
  static Future<Content> fetchContent() async {
    try {
      // Measure total time taken
      final stopwatch = Stopwatch()..start();

      // Fetch all content in parallel
      final results = await Future.wait([
        fetchContentData('https://valorant-api.com/v1/agents'),
        getRanks(),
        fetchContentData('https://valorant-api.com/v1/weapons'),
        fetchContentData('https://valorant-api.com/v1/maps'),
        fetchContentData('https://valorant-api.com/v1/gamemodes'),
        fetchContentData('https://valorant-api.com/v1/seasons'),
      ]);

      print('Total time: ${stopwatch.elapsed}');

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

  static Future<List<ContentItem>> getRanks() async {
    final stopwatch = Stopwatch()..start();
    Dio dio = Dio();
    try {
      var response =
          await dio.get('https://valorant-api.com/v1/competitivetiers');
      List<ContentItem> ranks = [];
      List<String> urls = [];
      List<String> ids = [];
      for (var data in response.data['data']) {
        for (var tier in data['tiers']) {
          if (tier['smallIcon'] != null) {
            String id = tier['tier'].toString();
            String url = tier['smallIcon'];
            ids.add(id);
            urls.add(url);
          }
        }
      }
      List<File?> images = await ImageCacheUtils.downloadImageFiles(urls, ids);
      print('len images: ${images.length}');
      for (var i = 0; i < images.length; i++) {
        if (images[i] != null) {
          String hash = ImageCacheUtils.generateImageHash(images[i]!);
          ranks.add(ContentItem.fromJsonRanks(response.data['data'][i], hash,
              iconUrl: images[i]!.path));
        }
      }
      print('Time taken for ranks: ${stopwatch.elapsed}');
      return ranks;
    } catch (e) {
      print('Error fetching ranks: $e');
      return [];
    }
  }

  static Future<List<ContentItem>> fetchContentData(String url) async {
    final stopwatch = Stopwatch()..start();
    Dio dio = Dio();
    String type = url.split('/').last;
    bool isWeapon = type == 'weapons';
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
          if (isWeapon) {
            contentItems.add(ContentItem.fromJsonWeapon(
                response.data['data'][i], hash,
                iconUrl: images[i]!.path));
          } else if (isMap) {
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
      print('Time taken for $type: ${stopwatch.elapsed}');
      return contentItems;
    } catch (e) {
      print('Error fetching $type: $e');
      return [];
    }
  }

  static Future<File?> downloadImage(String url, String id) async {
    final stopwatch = Stopwatch()..start();
    File? image = await ImageCacheUtils.downloadImageFile(url, id);
    print('Time taken to download image $id: ${stopwatch.elapsed}');
    return image;
  }
}
