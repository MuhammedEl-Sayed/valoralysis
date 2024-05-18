import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:valoralysis/models/user.dart';

class FileUtils {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localUserFile async {
    final path = await _localPath;
    final file = File('$path/users.txt');

    await file.create(recursive: true);

    return file;
  }

  static Future<File> get _localImageMapFile async {
    final path = await _localPath;
    final file = File('$path/imageMap.txt');

    await file.create(recursive: true);

    return file;
  }

//Re-work this to insert the user into the array and resave it. do same for read.
// then bring back prefs so you can save preferredPUUID
  static Future<int> writeUser(User user) async {
    try {
      if (user.puuid == '') {
        return -1;
      }
      final file = await _localUserFile;

      List<User> existingUsers = await readUsers();

      int index = existingUsers
          .indexWhere((existingUser) => existingUser.puuid == user.puuid);
      if (index != -1) {
        // If user exists, update it
        existingUsers[index] = user;
        file.writeAsString(jsonEncode(existingUsers));
        return existingUsers.length - 1;
      } else {
        // If user does not exist, add it
        existingUsers.add(user);
        file.writeAsString(jsonEncode(existingUsers));
        return existingUsers.length - 1;
      }
    } catch (e) {
      print('An error occurred: $e');
      return -1;
    }
  }

  static Future<List<User>> readUsers() async {
    try {
      final file = await _localUserFile;

      // Read the file
      final contents = await file.readAsString();

      if (contents.isEmpty) {
        return [];
      }

      List<dynamic> decodedJson = jsonDecode(contents);
      print('read: ${decodedJson.map((user) => User.fromJson(user)).toList()}');
      return decodedJson.map((user) => User.fromJson(user)).toList();
    } catch (e) {
      print(e);
      // If encountering an error, return 0
      return [];
    }
  }

  static Future<void> clearUsers() async {
    final file = await _localUserFile;
    file.writeAsString('');
  }

  static Future<int> writeImageMap(Map<String, List<String>> imageMap) async {
    try {
      final file = await _localImageMapFile;

      file.writeAsString(jsonEncode(imageMap));

      return 0;
    } catch (e) {
      print('An error occurred: $e');
      return -1;
    }
  }

  static Future<Map<String, List<String>>> readImageMap() async {
    try {
      final file = await _localImageMapFile;

      // Read the file
      final contents = await file.readAsString();

      if (contents.isEmpty) {
        return {};
      }

      Map<String, dynamic> decodedJson = jsonDecode(contents);
      Map<String, List<String>> imageMap = decodedJson
          .map((key, value) => MapEntry(key, List<String>.from(value)));

      return imageMap;
    } catch (e) {
      print(e);
      // If encountering an error, return empty map
      return {};
    }
  }

  static Future<void> clearImageMap() async {
    final file = await _localImageMapFile;
    file.writeAsString('');
  }
}
