import 'package:flutter/material.dart';
import 'package:flash_card/models/book_model.dart';

class BookViewModel extends ChangeNotifier {
  bool _editMode = false;
  BookModel _selectedBook = BookModel('', '', '', '', 0);

  BookViewModel(BookModel selectedBook) {
    this.selectedBook = selectedBook;
  }

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }

  get selectedBook => _selectedBook;
  set selectedBook(book) {
    _selectedBook = book;
  }
}
