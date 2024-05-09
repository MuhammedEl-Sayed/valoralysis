import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/matchHistory.txt');
  }

  static Future<File> writeMatchHistory(
      Map<String, dynamic> matchHistory) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(jsonEncode(matchHistory));
  }

  static Future<Map<String, dynamic>> readMatcHistory() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return jsonDecode(contents);
    } catch (e) {
      // If encountering an error, return 0
      return {};
    }
  }
}
