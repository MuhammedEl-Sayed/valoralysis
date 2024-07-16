import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentUtils {
  static Future<bool> isContentOld() async {
    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? oldManifestID = prefs.getString('oldManifestID');

    try {
      var response = await dio.get('https://valorant-api.com/v1/version');
      if (response.statusCode == 200) {
        String newManifestID = response.data['data']['manifestId'];
        if (oldManifestID != newManifestID) {
          await prefs.setString(
              'oldManifestID', newManifestID); // Update the stored manifest ID
          return true; // Content is old
        }
        return false; // Content is not old
      }
    } catch (e) {
      print('Error getting version: $e');
    }
    return true; // Assume content is old if there's an error
  }
}
