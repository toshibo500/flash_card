import 'package:flash_card/models/test_model.dart';
import 'package:flash_card/models/repositories/test_repository.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class TestResultViewModel extends ChangeNotifier {
  late String _id;
  TestModel _test = TestModel('', '', DateTime.now());
  BookModel _book = BookModel('', '', '', '', 0);
  TestModel get test => _test;
  BookModel get book => _book;

  TestResultViewModel(String id) {
    _id = id;
    _getTest();
  }

  void _getTest() {
    TestRepository.get(_id).then((test) {
      _test = test!;
      BookRepository.get(_test.bookId).then((book) {
        _book = book!;
        notifyListeners();
      });
    });
  }
}
