import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/folder_list_model.dart';

class FolderListViewModel extends ChangeNotifier {
  FolderListViewModel() {
    getFolders();
  }

  bool _editMode = false;
  final FolderListModel _folderListModel = FolderListModel();

  FolderListModel get folderListModel => _folderListModel;
  List<FolderModel> get items => _folderListModel.items;

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }

  void add(String title, String summary) {
    _folderListModel.add(title, summary);
    notifyListeners();
  }

  void removeAt(int index) {
    _folderListModel.removeAt(index);
    notifyListeners();
  }

  void updateAt(int index, String title, String summary) {
    _folderListModel.updateAt(index, title, summary);
    notifyListeners();
  }

  void getFolders() {
    _folderListModel.getFolders().then((value) => {notifyListeners()});
  }

  void setFolders() {
    _folderListModel.setFolders();
  }

  void reorder(int oldIndex, int newIndex) {
    final FolderModel item = _folderListModel.removeAt(oldIndex);
    _folderListModel.items.insert(newIndex, item);
    _folderListModel.setFolders();
    notifyListeners();
  }
}
