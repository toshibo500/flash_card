import 'dart:convert';

import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/preference_model.dart';
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

  setUp(() {
    final prefareceJson = jsonDecode(fixture('get_preference.json'));
    final PreferenceModel preModel = PreferenceModel.fromJson(prefareceJson);
    when(_prefRepository.get()).thenAnswer((_) async => preModel);

//    when(_quizRepository.create()).thenAnswer((_) async => );

    // _viewmodel = QuizViewModel(
    //     folderRepository: _folderRepository,
    //     cardRepository: _cardRepository,
    //     prefRepository: _prefRepository,
    //     quizRepository: _quizRepository,
    //     selectedFolder: FolderModel('00001', '00000', 'TOEIC600', '', 0),
    //     quizNum: 3);
  });
  group('Quiz repository testing', () {
    test('AddFolder Positive Testing', () async {});
  });
}
