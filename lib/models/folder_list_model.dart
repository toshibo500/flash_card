import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'folder_model.dart';

class FolderListModel {
  List<FolderModel> _folders = <FolderModel>[];

  List<FolderModel> get items => _folders;
  set items(folders) {
    _folders = folders;
  }

  FolderListModel() {
    getFolders();
  }

  void add(String title, String summary) {
    _folders.add(FolderModel(
        DateTime.now().millisecondsSinceEpoch.toString(), title, summary));
    setFolders();
  }

  FolderModel removeAt(int index) {
    FolderModel item = _folders.removeAt(index);
    setFolders();
    return item;
  }

  void updateAt(int index, String title, String summary) {
    _folders[index] = FolderModel(_folders[index].id, title, summary);
    setFolders();
  }

  final String _key = 'FolderList';

  Future<List> getFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_key)) {
      return [];
    }

    String? jsonStr = prefs.getString(_key);
    if (jsonStr == null) {
      return [];
    }
    var jsonObjs = jsonDecode(jsonStr) as List;
    _folders =
        jsonObjs.map((jsonObj) => FolderModel.fromJson(jsonObj)).toList();
    return _folders;
  }

  Future setFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(_folders.map((e) => e.toJson()).toList());
    prefs.setString(_key, json);
  }
}
