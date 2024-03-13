import 'package:flutter/material.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/models/rank.dart';

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
  }

  void updateContent(Content content) {
    _content = content;
    notifyListeners();
  }

  void updateMatchHistory(List<MatchHistory> matchHistory) {
    print("does this even get called?");
    try {
      _matchHistory = matchHistory;
      print(matchHistory);
      notifyListeners();
    } catch (e) {
      print('here??');
    }
  }

  void updateMatchDetails(List<Map<String, dynamic>> matchDetails) {
    _matchDetails = matchDetails;
    notifyListeners();
  }
}
