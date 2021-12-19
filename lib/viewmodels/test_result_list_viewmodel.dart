import 'package:flash_card/models/test_model.dart';
import 'package:flash_card/models/repositories/test_repository.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class TestResultListViewModel extends ChangeNotifier {
  late String _bookId;
  BookModel _book = BookModel('', '', '', '', 0);
  List<TestModel> _testList = [];

  BookModel get book => _book;
  List<TestModel> get testList => _testList;

  TestResultListViewModel(String bookId) {
    _bookId = bookId;
    _getResult();
  }

  void _getResult() async {
    _book = (await BookRepository.get(_bookId))!;
    _testList = await TestRepository.getList(_bookId, 100);
    notifyListeners();
  }

  void deleteByBook() async {
    if (_bookId != '') {
      TestRepository.deleteByBook(_bookId);
      _getResult();
    }
  }
}
