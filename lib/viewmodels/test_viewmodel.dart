import 'package:flash_card/models/repositories/test_repository.dart';
import 'package:flash_card/models/test_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/repositories/card_repository.dart';

class TestViewModel extends ChangeNotifier {
  BookModel _selectedBook = BookModel('', '', '', '', 0);
  late List<CardModel> _cardList = [];
  List<CardModel> get items => _cardList;

  int _index = 0;
  get index => _index;

  late CardModel _item = CardModel('', '', '', '', 0);
  CardModel get item => _item;
  bool get isEnded => _index >= _cardList.length;

  int _numberOfQuestions = 50;

  late TestModel _test;
  TestModel get test => _test;

  TestViewModel(BookModel selectedBook, int numberOfQuestions) {
    this.selectedBook = selectedBook;
    _numberOfQuestions = numberOfQuestions;
    startTest();
  }

  get selectedBook => _selectedBook;
  set selectedBook(book) {
    _selectedBook = book;
  }

  Future<void> _getCardList(int? limit) async {
    _cardList = await CardRepository.getListRandom(
        _selectedBook.id, limit ?? _numberOfQuestions);
  }

  void startTest() {
    TestRepository.create(_selectedBook.id, DateTime.now()).then((value) {
      _test = value!;
    });
    _getCardList(_numberOfQuestions).then((value) {
      _index = 0;
      if (_cardList.isNotEmpty) {
        _item = _cardList[_index];
        notifyListeners();
      }
    });
  }

  bool next() {
    _index++;
    if (isEnded) {
      return false;
    } else {
      _test.numberOfQuestions++;
      TestRepository.update(_test);
      _item = _cardList[_index];
      notifyListeners();
      return true;
    }
  }

  void correctAnswer() async {
    _test.numberOfCorrectAnswers++;
    _item.numberOfCorrectAnswers++;
    _item.testedAt = DateTime.now();
    await CardRepository.update(_item);
  }

  void wrongAnswer() async {
    _item.numberOfWrongAnswers++;
    _item.testedAt = DateTime.now();
    await CardRepository.update(_item);
  }
}
