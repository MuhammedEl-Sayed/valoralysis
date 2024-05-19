import 'package:flutter/material.dart';
import 'package:valoralysis/api/services/content_service.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/utils/content_utils.dart';
import 'package:valoralysis/utils/file_utils.dart';

class ContentProvider with ChangeNotifier {
  Content _content = Content(
      maps: [], agents: [], gameModes: [], acts: [], ranks: [], weapons: []);
  List<MatchHistory> _matchHistory = [];
  List<Map<String, dynamic>> _matchDetails = [];

  List<ContentItem> get maps => _content.maps;
  List<ContentItem> get agents => _content.agents;
  List<ContentItem> get gameModes => _content.gameModes;
  List<ContentItem> get acts => _content.acts;
  List<ContentItem> get weapons => _content.weapons;
  List<ContentItem> get ranks => _content.ranks;
  List<MatchHistory> get matchHistory => _matchHistory;
  List<Map<String, dynamic>> get matchDetails => _matchDetails;
  Content get content => _content;
  Content _contentCache = Content(
      maps: [], agents: [], gameModes: [], acts: [], ranks: [], weapons: []);

  ContentProvider() {
    _content.maps = <ContentItem>[];
    _content.agents = <ContentItem>[];
    _content.gameModes = <ContentItem>[];
    _content.acts = <ContentItem>[];
    _content.weapons = <ContentItem>[];
    _content.ranks = <ContentItem>[];
    _matchHistory = <MatchHistory>[];
    _matchDetails = <Map<String, dynamic>>[];
  }

  Future<void> init() async {
    await _loadImageCache();
  }

  Future<void> _loadImageCache() async {
    print('Loading image cache');
    _contentCache = await FileUtils.readImageMap();
    if (_contentCache.maps.isNotEmpty) {
      print('Image cache is not empty, updating content');
      await updateContent();
    } else {
      print('Image cache is empty, updating all content');
      await updateAllContent();
    }
    notifyListeners();
  }

  Future<void> updateAllContent() async {
    print('Updating all content');
    _content = await ContentService.fetchContent();
    print(_content.agents.length);
    await FileUtils.writeImageMap(_content);
    notifyListeners();
  }

  Future<void> updateContent() async {
    print('Updating content');
    Content newContent = await ContentService.fetchContent();
    if (ContentUtils.isContentOld(newContent, _content)) {
      print('Content is old, updating');
      _content = newContent;
      await FileUtils.writeImageMap(_content);
    } else {
      print('Content is not old, using cached content');
      _content = _contentCache;
    }
    notifyListeners();
  }
}
