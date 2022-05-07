import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';

class FolderViewModel extends ChangeNotifier {
  FolderRepository folderRepository;
  CardRepository cardRepository;
  PreferenceRepository prefRepository;
  QuizRepository quizRepository;

  bool _editMode = false;
  List<FolderModel> _folderList = [];
  List<FolderModel> get folderItems => _folderList;
  FolderModel selectedFolder;

  List<CardModel> _cardList = [];
  List<CardModel> get cardItems => _cardList;

  PreferenceModel _preference = PreferenceModel();
  PreferenceModel get preference => _preference;

  FolderViewModel(
      {required this.folderRepository,
      required this.cardRepository,
      required this.prefRepository,
      required this.quizRepository,
      required this.selectedFolder}) {
    getAllFolder(selectedFolder.id);
    getAllCard(selectedFolder.id);
    getPreference();
  }

  bool get hasSubFolders => _folderList.isNotEmpty;
  bool get hasCard => _cardList.isNotEmpty;
  bool get isEmptyFolder => _folderList.isEmpty && _cardList.isEmpty;

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }

  Future<void> addFolder(String title, String summary) async {
    FolderModel? item = await folderRepository.create(
        selectedFolder.id, title, summary, _folderList.length + 1);
    if (item != null) {
      _folderList.add(item);
      notifyListeners();
    }
  }

  Future<void> removeFolder(int index) async {
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
        await folderRepository.getByParentId(folderId);
    for (var subFolder in subFolders) {
      await _removeFolder(subFolder.id);
    }
    // 配下のCard, Quizを削除
    await cardRepository.deleteByFolderId(folderId);
    await quizRepository.deleteByFolderId(folderId);
    // Folderを削除
    return await folderRepository.delete(folderId);
  }

  Future<void> updateFolder(
      {required int index,
      String? parentId,
      required String title,
      required String summary,
      required int sequence}) async {
    String _id = _folderList[index].id;
    String _parentId = parentId ?? _folderList[index].parentId;
    int res =
        await folderRepository.update(_id, _parentId, title, summary, sequence);
    if (res > 0) {
      _folderList[index] =
          FolderModel(_id, _parentId, title, summary, sequence);
      notifyListeners();
    }
  }

  void getAllFolder(String parentId) async {
    _folderList = await folderRepository.getByParentId(parentId);
    for (var item in _folderList) {
      item.cards = await cardRepository.getAll(item.id);
    }
    notifyListeners();
  }

  Future<void> reorderFolder(int oldIndex, int newIndex) async {
    final FolderModel item = _folderList.removeAt(oldIndex);
    _folderList.insert(newIndex, item);
    await folderRepository.bulkUpdate(_folderList);
    notifyListeners();
  }

  void getPreference() {
    prefRepository.get().then((value) {
      _preference = value;
    });
    notifyListeners();
  }

  void getAllCard(String folderId) async {
    _cardList = await cardRepository.getAll(folderId);
    notifyListeners();
  }

  Future<void> addCard(
      String front, String back, String? frontLang, String? backLang) async {
    CardModel? item = await cardRepository.create(
        selectedFolder.id, front, back, _cardList.length + 1,
        frontLang: frontLang, backLang: backLang);
    if (item != null) {
      _cardList.add(item);
      notifyListeners();
    }
  }

  Future<void> removeCard(int index) async {
    int res = await cardRepository.delete(_cardList[index].id);
    if (res > 0) {
      _cardList.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> updateCard({required int index, required CardModel card}) async {
    int res = await cardRepository.update(card);
    if (res > 0) {
      _cardList[index] = card;
      notifyListeners();
    }
  }

  Future<void> reorderCard(int oldIndex, int newIndex) async {
    final CardModel item = _cardList.removeAt(oldIndex);
    _cardList.insert(newIndex, item);
    await cardRepository.bulkUpdate(_cardList);
    notifyListeners();
  }
}
