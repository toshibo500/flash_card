import 'package:flash_card/models/repositories/test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/repositories/book_repository.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/repositories/card_repository.dart';

class FolderViewModel extends ChangeNotifier {
  bool _editMode = false;
  List<BookModel> _bookList = [];
  List<BookModel> get items => _bookList;
  FolderModel _selectedFolder = FolderModel('', '', '', 0);

  FolderViewModel(FolderModel selectedFolder) {
    this.selectedFolder = selectedFolder;
    getAll(selectedFolder.id);
  }

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }

  get selectedFolder => _selectedFolder;
  set selectedFolder(folder) {
    _selectedFolder = folder;
  }

  void add(String title, String summary) async {
    BookModel? item = await BookRepository.create(
        selectedFolder.id, title, summary, _bookList.length + 1);
    if (item != null) {
      _bookList.add(item);
      notifyListeners();
    }
  }

  void remove(int index) async {
    // book id
    String bookId = _bookList[index].id;
    // 配下のCard, Testを削除
    CardRepository.deleteByBookId(bookId);
    TestRepository.deleteByBook(bookId);
    // bookを削除
    int res = await BookRepository.delete(bookId);
    if (res > 0) {
      _bookList.removeAt(index);
      notifyListeners();
    }
  }

  void update(
      {required int index,
      String? folderId,
      required String title,
      required String summary,
      required int sequence}) async {
    String _id = _bookList[index].id;
    String _folderId = folderId ?? _bookList[index].folderId;
    int res =
        await BookRepository.update(_id, _folderId, title, summary, sequence);
    if (res > 0) {
      _bookList[index] = BookModel(_id, _folderId, title, summary, sequence);
      notifyListeners();
    }
  }

  void getAll(String folderId) async {
    _bookList = await BookRepository.getAll(folderId);
    for (var item in _bookList) {
      item.cards = await CardRepository.getAll(item.id);
    }
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) async {
    final BookModel item = _bookList.removeAt(oldIndex);
    _bookList.insert(newIndex, item);
    await BookRepository.bulkUpdate(_bookList);
    notifyListeners();
  }
}
