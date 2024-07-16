import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ImageCacheUtils {
  static Future<File?> downloadImageFile(String url, String id) async {
    Dio dio = Dio();

    try {
      var response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = "${documentDirectory.path}/images";
      var filePathAndName = '$firstPath/$id.png';

      await Directory(firstPath).create(recursive: true);
      File file = File(filePathAndName);
      await file.writeAsBytes(response.data!, flush: true);
      return file;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<File?>> downloadImageFiles(
      List<String> urls, List<String> ids) async {
    if (urls.length != ids.length) {
      throw ArgumentError('The length of urls and ids must be the same.');
    }

    return Future.wait(urls.asMap().entries.map((entry) {
      int index = entry.key;
      String url = entry.value;
      return downloadImageFile(url, ids[index]);
    }).toList());
  }

  static Future<Map<String, File?>> downloadAbilityFiles(
      Map<String, String> abilitiesUrlMap, String id) async {
    Map<String, File?> abilityFiles = {};
    List<Future<void>> downloadTasks = [];

    for (var entry in abilitiesUrlMap.entries) {
      String suffix = entry.key;
      downloadTasks.add(
        downloadImageFile(entry.value, id + suffix).then((file) {
          abilityFiles[suffix] = file;
        }),
      );
    }

    // Wait for all download tasks to complete
    await Future.wait(downloadTasks);

    return abilityFiles;
  }
}
