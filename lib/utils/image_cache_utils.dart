import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

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

  static String encryptImage(File file) {
    String imageBytes = file.readAsBytesSync().toString();
    var bytes = utf8.encode(imageBytes);
    String digest = sha256.convert(bytes).toString();
    return digest;
  }
}
