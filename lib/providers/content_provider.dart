import 'dart:io';

import 'package:flutter/material.dart';
import 'package:valoralysis/api/services/content_service.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/models/rank.dart';
import 'package:valoralysis/utils/file_utils.dart';
import 'package:valoralysis/utils/image_cache_utils.dart';

class ContentProvider with ChangeNotifier {
  Content _content = Content(
      maps: [],
      agents: [],
      equips: [],
      gameModes: [],
      acts: [],
      ranks: [],
      weapons: []);
  List<MatchHistory> _matchHistory = [];
  List<Map<String, dynamic>> _matchDetails = [];

  List<ContentItem> get maps => _content.maps;
  List<ContentItem> get agents => _content.agents;
  List<ContentItem> get equips => _content.equips;
  List<ContentItem> get gameModes => _content.gameModes;
  List<ContentItem> get acts => _content.acts;
  List<WeaponItem> get weapons => _content.weapons;
  List<Rank> get ranks => _content.ranks;
  List<MatchHistory> get matchHistory => _matchHistory;
  List<Map<String, dynamic>> get matchDetails => _matchDetails;
  Map<String, List<String>> _imageCache = {};

  ContentProvider() {
    _content.maps = <ContentItem>[];
    _content.agents = <ContentItem>[];
    _content.equips = <ContentItem>[];
    _content.gameModes = <ContentItem>[];
    _content.acts = <ContentItem>[];
    _content.weapons = <WeaponItem>[];
    _content.ranks = <Rank>[];
    _matchHistory = <MatchHistory>[];
    _matchDetails = <Map<String, dynamic>>[];
    _loadImageCache();
  }

  Future<void> _loadImageCache() async {
    _imageCache = await FileUtils.readImageMap();
  }

  Future<void> updateContent() async {
    for (var item in [
      ..._content.maps,
      ..._content.agents,
      ..._content.equips,
      ..._content.gameModes,
      ..._content.acts,
      ..._content.weapons,
    ]) {
      await _updateImageCacheForItem(item);
    }

    print('fetching content');
    _content = await ContentService.fetchContent();
    print('fetched: ${_content.agents[0]}');
    notifyListeners();
  }

  Future<void> _updateImageCacheForItem(ContentItem item) async {
    if (!_imageCache.containsKey(item.id) ||
        _imageCache[item.id]![0] != item.iconUrl) {
      var file = await _downloadImage(item.iconUrl as String);
      var hash = ImageCacheUtils.generateImageHash(file);
      var path = file.path;

      _imageCache[item.id] = [hash, path];
    }
  }

  Future<File> _downloadImage(String url) {
    // Implement this method to download an image from the given URL and return
    // the File where it is stored on the device.
  }

  String getImagePath(String puuid) {
    return _imageCache.containsKey(puuid) ? _imageCache[puuid]![1] : '';
  }

//
  void updateMatchHistory(List<MatchHistory> matchHistory) {
    try {
      _matchHistory = matchHistory;
      notifyListeners();
    } catch (e) {}
  }

  void updateMatchDetails(List<Map<String, dynamic>> matchDetails) {
    _matchDetails = matchDetails;
    print('Collected ${matchDetails.length} matches');
    notifyListeners();
  }
}
