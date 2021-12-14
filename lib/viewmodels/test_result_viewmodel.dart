import 'package:flash_card/models/test_model.dart';
import 'package:flash_card/models/repositories/test_repository.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class TestResultViewModel extends ChangeNotifier {
  late String _id;
  TestModel _test = TestModel('', '', DateTime.now());
  BookModel _book = BookModel('', '', '', '', 0);
  List<TestModel> _testList = [];

  TestModel get test => _test;
  BookModel get book => _book;
  List<TestModel> get testList => _testList;

  TestResultViewModel(String id) {
    _id = id;
    _getResult();
  }

  void _getResult() async {
    _test = (await TestRepository.get(_id))!;
    _book = (await BookRepository.get(_test.bookId))!;
    _testList = await TestRepository.getList(_test.bookId, 5);
    notifyListeners();
  }
}
