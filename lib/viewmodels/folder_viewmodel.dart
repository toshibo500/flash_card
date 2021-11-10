import 'package:flash_card/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/book_list_model.dart';

class FolderViewModel extends ChangeNotifier {
  bool _editMode = false;
  final BookListModel _bookListModel = BookListModel();

  BookListModel get bookListModel => _bookListModel;
  List<BookModel> get items => _bookListModel.items;

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }

  void add(String folderId, String title, String summary) {
    _bookListModel.add(folderId, title, summary);
    notifyListeners();
  }

  void removeAt(int index) {
    _bookListModel.removeAt(index);
    notifyListeners();
  }

  void updateAt(int index, String folderId, String title, String summary) {
    _bookListModel.updateAt(index, folderId, title, summary);
    notifyListeners();
  }

  void getBooks() {
    _bookListModel.getBooks();
    notifyListeners();
  }

  void setFolders() {
    _bookListModel.setBooks();
  }

  void reorder(int oldIndex, int newIndex) {
    final BookModel item = _bookListModel.removeAt(oldIndex);
    _bookListModel.items.insert(newIndex, item);
    _bookListModel.setBooks();
    notifyListeners();
  }
}
