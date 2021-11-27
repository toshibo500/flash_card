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
  late CardModel _item;
  get item => _item;
  get isLast => _index <= _cardList.length;

  TestViewModel(BookModel selectedBook) {
    this.selectedBook = selectedBook;
  }

  get selectedBook => _selectedBook;
  set selectedBook(book) {
    _selectedBook = book;
  }

  void _getCardList(int limit) async {
    _cardList = await CardRepository.getListRandom(_selectedBook.id, 50);
  }

  void startTest(String bookId, int numberOfQuestions) {
    _getCardList(numberOfQuestions);
    _index = 0;
    _item = _cardList[_index];
    notifyListeners();
  }

  void next() {
    _index++;
    if (_index < _cardList.length) {
      _item = _cardList[_index];
      notifyListeners();
    } else {}
  }
}
