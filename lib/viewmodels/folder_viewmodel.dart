import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';

class FolderViewModel extends ChangeNotifier {
  bool _editMode = false;
  List<FolderModel> _folderList = [];
  List<FolderModel> get folderItems => _folderList;
  FolderModel _selectedFolder = FolderModel('', '', '', '', 0);

  List<CardModel> _cardList = [];
  List<CardModel> get cardItems => _cardList;

  PreferenceModel _preference = PreferenceModel();
  PreferenceModel get preference => _preference;

  FolderViewModel(FolderModel selectedFolder) {
    this.selectedFolder = selectedFolder;
    getAllFolder(_selectedFolder.id);
    getAllCard(_selectedFolder.id);
    getPreference();
  }

  bool get hasSubFolders => _folderList.isNotEmpty;
  bool get isEmptyFolder => _folderList.isEmpty && _cardList.isEmpty;

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }

  get selectedFolder => _selectedFolder;
  set selectedFolder(folder) {
    _selectedFolder = folder;
  }

  void addFolder(String title, String summary) async {
    FolderModel? item = await FolderRepository.create(
        selectedFolder.id, title, summary, _folderList.length + 1);
    if (item != null) {
      _folderList.add(item);
      notifyListeners();
    }
  }

  void removeFolder(int index) async {
    // folder id
    String folderId = _folderList[index].id;
    int res = await _removeFolder(folderId);
    if (res > 0) {
      notifyListeners();
      _folderList.removeAt(index);
    }
  }

  Future<int> _removeFolder(String folderId) async {
    // 再帰的にサブフォルダを削除
    List<FolderModel> subFolders =
        await FolderRepository.getByParentId(folderId);
    for (var subFolder in subFolders) {
      // 配下のCard, Quizを削除
      await CardRepository.deleteByFolderId(subFolder.id);
      await QuizRepository.deleteByFolderId(subFolder.id);
      await _removeFolder(subFolder.id);
    }
    // 配下のCard, Quizを削除
    await CardRepository.deleteByFolderId(folderId);
    await QuizRepository.deleteByFolderId(folderId);
    // Folderを削除
    return await FolderRepository.delete(folderId);
  }

  void updateFolder(
      {required int index,
      String? parentId,
      required String title,
      required String summary,
      required int sequence}) async {
    String _id = _folderList[index].id;
    String _parentId = parentId ?? _folderList[index].parentId;
    int res =
        await FolderRepository.update(_id, _parentId, title, summary, sequence);
    if (res > 0) {
      _folderList[index] =
          FolderModel(_id, _parentId, title, summary, sequence);
      notifyListeners();
    }
  }

  void getAllFolder(String parentId) async {
    _folderList = await FolderRepository.getByParentId(parentId);
    for (var item in _folderList) {
      item.cards = await CardRepository.getAll(item.id);
    }
    notifyListeners();
  }

  void reorderFolder(int oldIndex, int newIndex) async {
    final FolderModel item = _folderList.removeAt(oldIndex);
    _folderList.insert(newIndex, item);
    await FolderRepository.bulkUpdate(_folderList);
    notifyListeners();
  }

  void getPreference() {
    PreferenceRepository.get().then((value) {
      _preference = value;
    });
    notifyListeners();
  }

  void getAllCard(String folderId) async {
    _cardList = await CardRepository.getAll(folderId);
    notifyListeners();
  }

  void addCard(String front, String back) async {
    CardModel? item = await CardRepository.create(
        _selectedFolder.id, front, back, _cardList.length + 1);
    if (item != null) {
      _cardList.add(item);
      notifyListeners();
    }
  }

  void removeCard(int index) async {
    int res = await CardRepository.delete(_cardList[index].id);
    if (res > 0) {
      _cardList.removeAt(index);
      notifyListeners();
    }
  }

  void updateCard(
      {required int index,
      String? folderId,
      required String front,
      required String back,
      required int sequence}) async {
    String _id = _cardList[index].id;
    String _folderId = folderId ?? _cardList[index].folderId;
    CardModel row = CardModel(_id, _folderId, front, back, sequence);
    int res = await CardRepository.update(row);
    if (res > 0) {
      _cardList[index] = row;
      notifyListeners();
    }
  }

  void reorderCard(int oldIndex, int newIndex) async {
    final CardModel item = _cardList.removeAt(oldIndex);
    _cardList.insert(newIndex, item);
    await CardRepository.bulkUpdate(_cardList);
    notifyListeners();
  }
}
