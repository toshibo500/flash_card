import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'folder_model.dart';

class FolderListModel extends ChangeNotifier {
  final List<FolderModel> _folders = <FolderModel>[
    FolderModel('フォルダー1', 'サマリー1'),
    FolderModel('フォルダー2', 'サマリー2'),
    FolderModel('フォルダー3', 'サマリー3'),
    FolderModel('フォルダー4', 'サマリー4'),
  ];

  List<FolderModel> get items => _folders;

  void add(FolderModel folder) {
    _folders.add(folder);
    notifyListeners();
  }

  final String _key = 'FlderList';
/*   Future getFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_key)) {
      return [];
    }
    String? jsonStr = prefs.getString(_key);
    var jsonObjs = jsonDecode(jsonStr!) as List;
    folders = jsonObjs.map((jsonObj) => FolderModel.fromJson(jsonObj)).toList();
    notifyListeners();
  }

  Future setFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(folders.map((e) => e.toJson()).toList());
    prefs.setString(_key, json);
  } */

}
