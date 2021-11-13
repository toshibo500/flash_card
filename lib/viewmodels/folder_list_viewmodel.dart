import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';

class FolderListViewModel extends ChangeNotifier {
  FolderListViewModel() {
    getFolders();
  }

  bool _editMode = false;
  List<FolderModel> _folderList = [];
  List<FolderModel> get items => _folderList;

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }

  addFolder(String title, String summary) async {
    FolderModel? item = await FolderRepository.create(title, summary);
    if (item != null) {
      _folderList.add(item);
      notifyListeners();
    }
  }

  void removeFolder(int index) async {
    int res = await FolderRepository.delete(_folderList[index].id);
    if (res > 0) {
      _folderList.removeAt(index);
      notifyListeners();
    }
  }

  void updateFolder(int index, String title, String summary) {
    notifyListeners();
  }

  void getFolders() async {
    _folderList = await FolderRepository.getAll();
    notifyListeners();
  }

  void setFolders() {}

  void reorder(int oldIndex, int newIndex) {
    final FolderModel item = _folderList.removeAt(oldIndex);
    _folderList.insert(newIndex, item);
    notifyListeners();
  }
}
