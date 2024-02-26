import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:pool/pool.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/models/auth_info.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/models/match_history.dart';

class HistoryService {
  static Future<List<MatchHistory>> fetchMatchHistory(
      String shard,
      int startIndex,
      int endIndex,
      String queueType,
      AuthInfo authInfo,
      String puuid) async {
    Dio dio = AuthService.prepareDio(authInfo);

    try {
      var response = await dio.get(
        'https://pd.$shard.a.pvp.net/match-history/v1/history/$puuid?startIndex=$startIndex&endIndex=$endIndex&queue=$queueType',
      );
      if (response.statusCode == 429) {
        print('Too many requests. Stopping further requests.');
        return [];
      }
      Map<String, dynamic> responseData = jsonDecode(response.data);
      List<dynamic> historyList = responseData['History'];
      return historyList.map((item) => MatchHistory.fromJson(item)).toList();
    } catch (e) {
      print('Request error: $e');
      return [];
    }
  }

  static Future<List<MatchHistory>> fetchMatchHistoryInIncrements(
      String shard,
      int startIndex,
      int endIndex,
      String queueType,
      AuthInfo authInfo,
      String puuid) async {
    int startIndex = 0;
    int endIndex = 25;
    bool shouldContinue = true;
    List<MatchHistory> data = [];
    while (shouldContinue) {
      try {
        final newHistory = await fetchMatchHistory(
            shard, startIndex, endIndex, queueType, authInfo, puuid);
        print('here');
        if (newHistory.isNotEmpty) {
          data.insertAll(data.length, newHistory);
        } // Update the start and end indices for the next batch
        else {
          print('Length match history: + ${data.length}');
          return data;
        }
        startIndex += 25;
        endIndex += 25;
      } catch (e) {
        print('Request error: $e');
        shouldContinue = false; // Stop the loop if an error occurs
      }
    }
    return data;
  }

  static Future<Map<String, dynamic>> fetchMatchDetails(
      String shard, String matchID, AuthInfo authInfo,
      [bool? stop = false]) async {
    if (stop == true) {
      return {};
    }
    Dio dio = AuthService.prepareDio(authInfo);
    try {
      var response = await dio
          .get('https://pd.$shard.a.pvp.net/match-details/v1/matches/$matchID');
      if (response.statusCode == 429) {
        print('Too many requests. Stopping further requests.');
        return {};
      }
      return response.data;
    } catch (e) {
      print('Request error: $e');
      return {};
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAllMatchDetails(
      String shard, List<String> matchIDs, AuthInfo authInfo) async {
    final pool = Pool(10); // Adjust this number as needed
    List<Map<String, dynamic>> matchDetails = [];
    bool stop = false;
    await Future.wait(matchIDs.map((matchID) async {
      await pool.withResource(() async {
        var detail = await fetchMatchDetails(shard, matchID, authInfo, stop);
        if (detail.isNotEmpty) {
          matchDetails.add(detail);
        } else {
          stop = true;
        }
        matchDetails.add(detail);
      });
    }));

    print('Length match details: + ${matchDetails.length}');

    return matchDetails;
  }
}
