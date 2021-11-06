import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'book_model.dart';

class BookListModel extends ChangeNotifier {
  List<BookModel> _books = <BookModel>[];

  List<BookModel> get items => _books;
  set items(books) {
    _books = books;
  }

  BookListModel() {
    getBooks();
  }

  void add(String folderId, String title, String summary) {
    _books.add(BookModel(DateTime.now().millisecondsSinceEpoch.toString(),
        folderId, title, summary));
    setBooks();
    notifyListeners();
  }

  void removeAt(int index) {
    _books.removeAt(index);
    setBooks();
    notifyListeners();
  }

  void updateAt(int index, String folderId, String title, String summary) {
    _books[index] = BookModel(_books[index].id, folderId, title, summary);
    setBooks();
    notifyListeners();
  }

  final String _key = 'BookList';

  Future getBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_key)) {
      return [];
    }
    String? jsonStr = prefs.getString(_key);
    var jsonObjs = jsonDecode(jsonStr!) as List;
    _books = jsonObjs.map((jsonObj) => BookModel.fromJson(jsonObj)).toList();
    notifyListeners();
  }

  Future setBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(_books.map((e) => e.toJson()).toList());
    prefs.setString(_key, json);
  }
}
