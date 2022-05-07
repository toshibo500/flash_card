import 'dart:convert';

import 'package:flash_card/globals.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flash_card/models/quiz_model.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flash_card/viewmodels/quiz_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fixture.dart';
import 'quiz_viewmodel_test.mocks.dart';

@GenerateMocks(
    [FolderRepository, CardRepository, PreferenceRepository, QuizRepository])
void main() {
  MockFolderRepository _folderRepository = MockFolderRepository();
  MockCardRepository _cardRepository = MockCardRepository();
  MockPreferenceRepository _prefRepository = MockPreferenceRepository();
  MockQuizRepository _quizRepository = MockQuizRepository();

  late QuizViewModel _viewmodel;
  FolderModel selectedFolder = FolderModel('00001', '00000', 'TOEIC600', '', 0);

  setUp(() {
    final prefareceJson = jsonDecode(fixture('get_preference.json'));
    final PreferenceModel preModel = PreferenceModel.fromJson(prefareceJson);
    when(_prefRepository.get()).thenAnswer((_) async => preModel);

    final QuizModel quizModel = QuizModel(
        DateTime.now().millisecondsSinceEpoch.toString(),
        selectedFolder.id,
        DateTime.now());
    when(_quizRepository.create(any, any)).thenAnswer((_) async => quizModel);
    final cardListJson = jsonDecode(fixture('get_card_list.json'));
    List<CardModel> cardList = [];
    for (var cardJson in cardListJson) {
      cardList.add(CardModel.fromJson(cardJson));
    }
    const int _quizNum = 3;
    when(_cardRepository.getList(
            folderId: selectedFolder.id,
            orderBy: Globals().quizOrderItems[0],
            orderMethod: '',
            limit: _quizNum))
        .thenAnswer((_) async => cardList);

    _viewmodel = QuizViewModel(
        folderRepository: _folderRepository,
        cardRepository: _cardRepository,
        prefRepository: _prefRepository,
        quizRepository: _quizRepository,
        selectedFolder: selectedFolder,
        quizNum: _quizNum);
  });
  group('Quiz viewmodl testing', () {
    test('Items Testing', () async {});
  });
}
