import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flash_card/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';
import 'package:flash_card/globals.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';

class QuizViewModel extends ChangeNotifier {
  FolderModel _selectedFolder = FolderModel('', '', '', '', 0);
  late List<CardModel> _cardList = [];
  int _index = 0;
  late CardModel _item = CardModel('', '', '', '', 0);
  int _quizNum = 50;
  late QuizModel _quiz;
  PreferenceModel _preference = PreferenceModel();

  QuizViewModel(FolderModel selectedFolder, int quizNum) {
    this.selectedFolder = selectedFolder;
    _quizNum = quizNum;
    getPreference().then((value) {
      startQuiz();
    });
  }

  List<CardModel> get items => _cardList;
  get index => _index;
  CardModel get item => _item;
  bool get isEnded => _index >= _cardList.length;
  QuizModel get quiz => _quiz;

  PreferenceModel get preference => _preference;
  Future<void> getPreference() async {
    _preference = await PreferenceRepository.get();
  }

  get selectedFolder => _selectedFolder;
  set selectedFolder(folder) {
    _selectedFolder = folder;
  }

  String get question {
    return _preference.question == Globals.cardFrontKey
        ? _item.front
        : _item.back;
  }

  String get answer {
    return _preference.question == Globals.cardFrontKey
        ? _item.back
        : _item.front;
  }

  String get questionLocaleId {
    return _preference.question == Globals.cardFrontKey
        ? _preference.frontSideLang ?? ''
        : _preference.backSideLang ?? '';
  }

  String get answerLocaleId {
    return _preference.question == Globals.cardFrontKey
        ? _preference.backSideLang ?? ''
        : _preference.frontSideLang ?? '';
  }

  String get answerLocaleName {
    return _preference.question == Globals.cardFrontKey
        ? _preference.backSideLangName ?? ''
        : _preference.frontSideLangName ?? '';
  }

  Future<void> _getCardList(int? limit) async {
    String? orderBy = Globals().quizOrderItems[_preference.quizOrder];
    String? orderMethod =
        Globals().quizOrderMethodItems[_preference.quizOrderMethod];

    _cardList = await CardRepository.getList(
        folderId: _selectedFolder.id,
        orderBy: orderBy!,
        orderMethod: _preference.quizOrder == Globals.quizOrderRandom
            ? ''
            : orderMethod!,
        limit: limit ?? _quizNum);
  }

  void startQuiz() {
    QuizRepository.create(_selectedFolder.id, DateTime.now()).then((value) {
      _quiz = value!;
    });
    _getCardList(_quizNum).then((value) {
      _index = 0;
      if (_cardList.isNotEmpty) {
        _item = _cardList[_index];
        notifyListeners();
      }
    });
  }

  bool next() {
    _quiz.quizNum++;
    DateTime dt = DateTime.now();
    _quiz.endedAt = dt;
    QuizRepository.update(_quiz);
    updateFolder(dt);

    _index++;
    if (isEnded) {
      return false;
    } else {
      _item = _cardList[_index];
      notifyListeners();
      return true;
    }
  }

  void correctAnswer() async {
    _quiz.correctNum++;
    _item.correctNum++;
    DateTime dt = DateTime.now();
    _item.quizedAt = dt;
    await CardRepository.update(_item);
  }

  void wrongAnswer() async {
    _item.wrongNum++;
    _item.quizedAt = DateTime.now();
    DateTime dt = DateTime.now();
    _item.quizedAt = dt;
    await CardRepository.update(_item);
  }

  void updateFolder(DateTime time) {
    _selectedFolder.quizedAt = time;
    FolderRepository.updateWithModel(_selectedFolder);
  }
}
