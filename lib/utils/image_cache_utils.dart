import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ImageCacheUtils {
/*
  * So a summary of what we are trying to accomplish:
  * 1. We want to download images in the case of:
  *   a. no images stored on device
  *   b. image hash doesnt match remote
  * 2. Both of these checks should happen asap, after reading user data.
  * 3. If image needs to be downloaded, we update the hash
  * So how do we store this? I'm guessing puuid/hash. and probably also path to the image.

  * Next step is how do I do this via code?
  * contentProvider is already holding a lot of this info, so we can add a contentStorageMap to it, and then ImageCacheUtils to do stuff, use FileUtils to write to file.
*/

  // What I need to be able to do is convert an image back and forth between sha256

  static String generateImageHash(File file) {
    String imageBytes = file.readAsBytesSync().toString();
    var bytes = utf8.encode(imageBytes);
    String digest = sha256.convert(bytes).toString();
    return digest;
  }

  static bool compareImageHash(File file, String hash) {
    return generateImageHash(file) == hash;
  }

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
}
