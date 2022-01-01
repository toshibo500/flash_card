import 'package:flash_card/models/quiz_model.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class QuizResultViewModel extends ChangeNotifier {
  late String _id;
  QuizModel _quiz = QuizModel('', '', DateTime.now());
  BookModel _book = BookModel('', '', '', '', 0);
  List<QuizModel> _quizList = [];

  QuizModel get quiz => _quiz;
  BookModel get book => _book;
  List<QuizModel> get quizList => _quizList;

  QuizResultViewModel(String id) {
    _id = id;
    _getResult();
  }

  void _getResult() async {
    _quiz = (await QuizRepository.get(_id))!;
    _book = (await BookRepository.get(_quiz.bookId))!;
    _quizList = await QuizRepository.getList(_quiz.bookId, 5, 'DESC');
    // 最新5件を取得し、古いものから表示したいので反転
    _quizList = _quizList.reversed.toList();
    notifyListeners();
  }
}
