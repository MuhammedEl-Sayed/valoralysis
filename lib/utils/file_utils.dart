import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:valoralysis/models/content.dart';
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
      } else {
        // If user does not exist, add it
        existingUsers.add(user);
      }
      await file.writeAsString(jsonEncode(existingUsers));
      return existingUsers.length - 1;
    } catch (e) {
      print('An error occurred: $e');
      return -1;
    }
  }

  static Future<List<User>> readUsers() async {
    try {
      final file = await _localUserFile;

      // Read the file
      final contents = await file
          .openRead()
          .transform(utf8.decoder)
          .transform(json.decoder)
          .first;

      if (contents == null) {
        return [];
      }

      List<User> users =
          (contents as List).map((user) => User.fromJson(user)).toList();
      return users;
    } catch (e) {
      print(e);
      // If encountering an error, return an empty list
      return [];
    }
  }

  static Future<void> clearUsers() async {
    final file = await _localUserFile;
    await file.writeAsString('');
  }

  static Future<int> writeImageMap(Content content) async {
    try {
      final file = await _localImageMapFile;
      await file.writeAsString(jsonEncode(content.toJson()));
      return 0;
    } catch (e) {
      print('An error occurred: $e');
      return -1;
    }
  }

  static Future<Content> readImageMap() async {
    try {
      final file = await _localImageMapFile;

      // Read the file
      final contents = await file
          .openRead()
          .transform(utf8.decoder)
          .transform(json.decoder)
          .first;

      return Content.fromJson(contents as Map<String, dynamic>);
    } catch (e) {
      print('error reading: $e');
      // If encountering an error, return empty Content
      return Content(
        maps: [],
        agents: [],
        gameModes: [],
        acts: [],
        ranks: [],
        weapons: [],
      );
    }
  }

  static Future<void> clearImageMap() async {
    final file = await _localImageMapFile;
    await file.writeAsString('');
  }
}
