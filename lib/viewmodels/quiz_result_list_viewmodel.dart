import 'package:flash_card/models/quiz_model.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flutter/material.dart';

class QuizResultListViewModel extends ChangeNotifier {
  late String _folderId;
  FolderModel _folder = FolderModel('', '', '', '', 0);
  List<QuizModel> _quizList = [];

  FolderModel get folder => _folder;
  List<QuizModel> get quizList => _quizList;

  QuizResultListViewModel(String folderId) {
    _folderId = folderId;
    _getResult();
  }

  void _getResult() async {
    _folder = (await FolderRepository().getById(_folderId))!;
    _quizList = await QuizRepository().getList(_folderId, 100);
    notifyListeners();
  }

  void deleteByFolderId() async {
    if (_folderId != '') {
      QuizRepository().deleteByFolderId(_folderId);
      _getResult();
    }
  }
}
