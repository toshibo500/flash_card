import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'folder_model.dart';

class FolderListModel extends ChangeNotifier {
  List<FolderModel> _folders = <FolderModel>[];

  List<FolderModel> get items => _folders;
  set items(folders) {
    _folders = folders;
  }

  FolderListModel() {
    getFolders();
  }

  void add(FolderModel folder) {
    _folders.add(folder);
    setFolders();
    notifyListeners();
  }

  void removeAt(int index) {
    _folders.removeAt(index);
    setFolders();
    notifyListeners();
  }

  void updateAt(int index, FolderModel folder) {
    _folders[index] = folder;
    setFolders();
    notifyListeners();
  }

  final String _key = 'FolderList';

  Future getFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_key)) {
      return [];
    }
    String? jsonStr = prefs.getString(_key);
    var jsonObjs = jsonDecode(jsonStr!) as List;
    _folders =
        jsonObjs.map((jsonObj) => FolderModel.fromJson(jsonObj)).toList();
    notifyListeners();
  }

  Future setFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(_folders.map((e) => e.toJson()).toList());
    prefs.setString(_key, json);
  }
}
