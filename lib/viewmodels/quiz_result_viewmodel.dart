import 'package:flash_card/models/quiz_model.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flutter/material.dart';

class QuizResultViewModel extends ChangeNotifier {
  late String _id;
  QuizModel _quiz = QuizModel('', '', DateTime.now());
  FolderModel _folder = FolderModel('', '', '', '', 0);
  List<QuizModel> _quizList = [];

  QuizModel get quiz => _quiz;
  FolderModel get folder => _folder;
  List<QuizModel> get quizList => _quizList;

  QuizResultViewModel(String id) {
    _id = id;
    _getResult();
  }

  void _getResult() async {
    _quiz = (await QuizRepository.get(_id))!;
    _folder = (await FolderRepository.getById(_quiz.folderId))!;
    _quizList = await QuizRepository.getList(_quiz.folderId, 5, 'DESC');
    // 最新5件を取得し、古いものから表示したいので反転
    _quizList = _quizList.reversed.toList();
    notifyListeners();
  }
}
