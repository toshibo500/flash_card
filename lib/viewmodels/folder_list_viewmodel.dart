import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';

class FolderListViewModel extends ChangeNotifier {
  FolderListViewModel() {
    getAll();
  }

  bool _editMode = false;
  List<FolderModel> _folderList = [];
  List<FolderModel> get items => _folderList;

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }

  add(String title, String summary) async {
    FolderModel? item =
        await FolderRepository.create(title, summary, _folderList.length + 1);
    if (item != null) {
      _folderList.add(item);
      notifyListeners();
    }
  }

  void remove(int index) async {
    int res = await FolderRepository.delete(_folderList[index].id);
    if (res > 0) {
      _folderList.removeAt(index);
      notifyListeners();
    }
  }

  void update(int index, String title, String summary, int sequence) async {
    String _id = _folderList[index].id;
    int res = await FolderRepository.update(_id, title, summary, sequence);
    if (res > 0) {
      _folderList[index] = FolderModel(_id, title, summary, sequence);
      notifyListeners();
    }
  }

  void getAll() async {
    _folderList = await FolderRepository.getAll();
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) async {
    final FolderModel item = _folderList.removeAt(oldIndex);
    _folderList.insert(newIndex, item);
    await FolderRepository.bulkUpdate(_folderList);
    notifyListeners();
  }
}
