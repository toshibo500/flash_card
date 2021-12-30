import 'package:flash_card/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flash_card/models/repositories/book_repository.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';

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
    // flder id
    String folderId = _folderList[index].id;
    // 配下のbookを取得
    List<BookModel> books = await BookRepository.getAll(folderId);
    // 配下のCard, Quizを削除
    for (var e in books) {
      CardRepository.deleteByBookId(e.id);
      QuizRepository.deleteByBook(e.id);
    }
    // フォルダを削除
    int res = await FolderRepository.delete(folderId);
    if (res > 0) {
      _folderList.removeAt(index);
      notifyListeners();
    }
  }

  void update(
      {required int index,
      required String title,
      required String summary,
      required int sequence}) async {
    String _id = _folderList[index].id;
    int res = await FolderRepository.update(_id, title, summary, sequence);
    if (res > 0) {
      _folderList[index] = FolderModel(_id, title, summary, sequence);
      notifyListeners();
    }
  }

  void getAll() async {
    _folderList = await FolderRepository.getAll();
    for (var folder in _folderList) {
      folder.books = await BookRepository.getAll(folder.id);
    }
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) async {
    final FolderModel item = _folderList.removeAt(oldIndex);
    _folderList.insert(newIndex, item);
    await FolderRepository.bulkUpdate(_folderList);
    notifyListeners();
  }
}
