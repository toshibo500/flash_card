import 'package:flash_card/models/quiz_model.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class QuizResultListViewModel extends ChangeNotifier {
  late String _bookId;
  BookModel _book = BookModel('', '', '', '', 0);
  List<QuizModel> _quizList = [];

  BookModel get book => _book;
  List<QuizModel> get quizList => _quizList;

  QuizResultListViewModel(String bookId) {
    _bookId = bookId;
    _getResult();
  }

  void _getResult() async {
    _book = (await BookRepository.get(_bookId))!;
    _quizList = await QuizRepository.getList(_bookId, 100);
    notifyListeners();
  }

  void deleteByBook() async {
    if (_bookId != '') {
      QuizRepository.deleteByBook(_bookId);
      _getResult();
    }
  }
}
