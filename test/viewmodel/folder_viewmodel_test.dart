import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flash_card/viewmodels/folder_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'folder_viewmodel_test.mocks.dart';

@GenerateMocks(
    [FolderRepository, CardRepository, PreferenceRepository, QuizRepository])
void main() {
  MockFolderRepository _folderRepository = MockFolderRepository();
  MockCardRepository _cardRepository = MockCardRepository();
  MockPreferenceRepository _prefRepository = MockPreferenceRepository();
  MockQuizRepository _quizRepository = MockQuizRepository();

  late FolderViewModel _viewmodel;

  FolderModel _folder1 = FolderModel('00002', '00001', 'Day1', '', 2,
      DateTime(2021, 12, 28, 13, 00, 00), false);
  FolderModel _folder2 = FolderModel('00003', '00001', 'Day2', '', 3,
      DateTime(2021, 12, 28, 13, 00, 00), false);
  CardModel _card1 = CardModel('00001', '00001', 'hello', 'こんにちわ', 0, 0, 0,
      DateTime.now(), 'en-US', 'jp-JP');
  CardModel _card2 = CardModel('00002', '00001', 'see ya', 'じゃ', 0, 0, 0,
      DateTime.now(), 'en-US', 'jp-JP');

  setUp(() {
    when(_folderRepository.getByParentId(any))
        .thenAnswer((_) async => [_folder1]);
    when(_cardRepository.getAll(any)).thenAnswer((_) async => [_card1]);
    when(_prefRepository.get()).thenAnswer((_) async => PreferenceModel());
    _viewmodel = FolderViewModel(
        folderRepository: _folderRepository,
        cardRepository: _cardRepository,
        prefRepository: _prefRepository,
        quizRepository: _quizRepository,
        selectedFolder: FolderModel('00001', '00000', 'TOEIC600', '', 0));
  });

  group('Folder repository testing', () {
    test('AddFolder Positive Testing', () async {
      when(_folderRepository.create(any, any, any, any))
          .thenAnswer((_) async => _folder2);
      await _viewmodel.addFolder(_folder2.title, _folder2.summary);
      verify(_folderRepository.create(
          '00001', _folder2.title, _folder2.summary, 2));
      expect(
          _viewmodel.folderItems,
          isA<List<FolderModel>>()
              .having((list) => list, 'isNotNull', isNotNull)
              .having((list) => list.length, 'length', 2)
              .having((list) => list[0].id, 'id', '00002')
              .having((list) => list[1].id, 'id', '00003'));
    });
    test('AddFolder Negative Testing', () async {
      when(_folderRepository.create(any, any, any, any))
          .thenAnswer((_) async => null);
      await _viewmodel.addFolder(_folder2.title, _folder2.summary);
      verify(_folderRepository.create(
          '00001', _folder2.title, _folder2.summary, 2));
      expect(
          _viewmodel.folderItems,
          isA<List<FolderModel>>()
              .having((list) => list, 'isNotNull', isNotNull)
              .having((list) => list.length, 'length', 1)
              .having((list) => list[0].id, 'id', '00002'));
    });
    test('RemoveFolder Positive Testing', () async {
      final _subFolders = [_folder1];
      // サブフォルダを１つ設定。(1回呼ばれたらリストがなくなって空になる)
      when(_folderRepository.getByParentId(any)).thenAnswer(
          (_) async => _subFolders.isNotEmpty ? [_subFolders.removeAt(0)] : []);
      when(_folderRepository.delete(any)).thenAnswer((_) async => 1);
      when(_cardRepository.deleteByFolderId(any)).thenAnswer((_) async => 1);
      when(_quizRepository.deleteByFolderId(any)).thenAnswer((_) async => 1);
      await _viewmodel.removeFolder(0);
      verify(_folderRepository.delete(any)).called(2);
      verify(_cardRepository.deleteByFolderId(any)).called(2);
      verify(_quizRepository.deleteByFolderId(any)).called(2);
      expect(_viewmodel.folderItems,
          isA<List<FolderModel>>().having((list) => list.length, 'length', 0));
    });

    test('RemoveFolder Negative Testing', () async {
      when(_folderRepository.getByParentId(any)).thenAnswer((_) async => []);
      when(_folderRepository.delete(any)).thenAnswer((_) async => 0);
      when(_cardRepository.deleteByFolderId(any)).thenAnswer((_) async => 0);
      when(_quizRepository.deleteByFolderId(any)).thenAnswer((_) async => 0);
      await _viewmodel.removeFolder(0);
      verify(_folderRepository.delete(any)).called(1);
      verify(_cardRepository.deleteByFolderId(any)).called(1);
      verify(_quizRepository.deleteByFolderId(any)).called(1);
      expect(_viewmodel.folderItems,
          isA<List<FolderModel>>().having((list) => list.length, 'length', 1));
    });

    test('UpdateFolder positive testing', () async {
      when(_folderRepository.update(any, any, any, any, any))
          .thenAnswer((_) async => 1);
      await _viewmodel.updateFolder(
          index: 0,
          parentId: _folder1.parentId,
          sequence: 1,
          summary: _folder2.summary,
          title: _folder2.title);
      verify(_folderRepository.update(
          _folder1.id, _folder1.parentId, _folder2.title, _folder2.summary, 1));
      expect(
          _viewmodel.folderItems,
          isA<List<FolderModel>>()
              .having((list) => list, 'isNotNull', isNotNull)
              .having((list) => list.length, 'length', 1)
              .having((list) => list[0].id, 'id', '00002')
              .having((list) => list[0].parentId, 'parentId', '00001')
              .having((list) => list[0].title, 'title', 'Day2'));
    });

    test('UpdateFolder negative testing', () async {
      when(_folderRepository.update(any, any, any, any, any))
          .thenAnswer((_) async => 0);
      await _viewmodel.updateFolder(
          index: 0,
          parentId: _folder1.parentId,
          sequence: 1,
          summary: _folder2.summary,
          title: _folder2.title);
      verify(_folderRepository.update(
          _folder1.id, _folder1.parentId, _folder2.title, _folder2.summary, 1));
      expect(
          _viewmodel.folderItems,
          isA<List<FolderModel>>()
              .having((list) => list, 'isNotNull', isNotNull)
              .having((list) => list.length, 'length', 1)
              .having((list) => list[0].id, 'id', '00002')
              .having((list) => list[0].parentId, 'parentId', '00001')
              .having((list) => list[0].title, 'title', 'Day1'));
    });

    test('ReordreFolder testing', () async {
      when(_folderRepository.bulkUpdate(any)).thenAnswer((_) async => 2);
      when(_folderRepository.create(any, any, any, any))
          .thenAnswer((_) async => _folder2);

      await _viewmodel.addFolder(_folder2.title, _folder2.summary);
      await _viewmodel.reorderFolder(1, 0);
      verify(_folderRepository.bulkUpdate(any)).called(1);
      expect(
          _viewmodel.folderItems,
          isA<List<FolderModel>>()
              .having((list) => list.length, 'length', 2)
              .having((list) => list[0].id, 'id', '00003'));
    });
  });

  group('Card repository testing', () {
    test('AddCard positive testing', () async {
      when(_cardRepository.create(any, any, any, 2,
              frontLang: captureAnyNamed('frontLang'),
              backLang: captureAnyNamed('backLang')))
          .thenAnswer((_) async => _card2);
      await _viewmodel.addCard(
          _card2.front, _card2.back, _card2.frontLang, _card2.backLang);
      verify(_cardRepository.create('00001', _card2.front, _card2.back, 2,
          frontLang: _card2.frontLang, backLang: _card2.backLang));
      expect(
          _viewmodel.cardItems,
          isA<List<CardModel>>()
              .having((list) => list, 'isNotNull', isNotNull)
              .having((list) => list.length, 'length', 2)
              .having((list) => list[0].id, 'id', '00001')
              .having((list) => list[1].id, 'id', '00002'));
    });

    test('AddCard negative testing', () async {
      when(_cardRepository.create(any, any, any, 2,
              frontLang: captureAnyNamed('frontLang'),
              backLang: captureAnyNamed('backLang')))
          .thenAnswer((_) async => null);
      await _viewmodel.addCard(
          _card2.front, _card2.back, _card2.frontLang, _card2.backLang);
      verify(_cardRepository.create('00001', _card2.front, _card2.back, 2,
          frontLang: _card2.frontLang, backLang: _card2.backLang));
      expect(
          _viewmodel.cardItems,
          isA<List<CardModel>>()
              .having((list) => list, 'isNotNull', isNotNull)
              .having((list) => list.length, 'length', 1)
              .having((list) => list[0].id, 'id', '00001'));
    });

    test('RemoveCard positive testing', () async {
      when(_cardRepository.delete(any)).thenAnswer((_) async => 1);
      await _viewmodel.removeCard(0);
      verify(_cardRepository.delete(any)).called(1);
      expect(_viewmodel.cardItems,
          isA<List<CardModel>>().having((list) => list.length, 'length', 0));
    });

    test('RemoveCard negative testing', () async {
      when(_cardRepository.delete(any)).thenAnswer((_) async => 0);
      await _viewmodel.removeCard(0);
      verify(_cardRepository.delete(any)).called(1);
      expect(_viewmodel.cardItems,
          isA<List<CardModel>>().having((list) => list.length, 'length', 1));
    });
    test('UpdateCard positive testing', () async {
      when(_cardRepository.update(any)).thenAnswer((_) async => 1);
      CardModel _card3 =
          CardModel(_card1.id, _card1.folderId, _card2.front, _card2.back, 1);
      await _viewmodel.updateCard(index: 0, card: _card3);
      verify(_cardRepository.update(_card3)).called(1);
      expect(
          _viewmodel.cardItems,
          isA<List<CardModel>>()
              .having((list) => list, 'isNotNull', isNotNull)
              .having((list) => list.length, 'length', 1)
              .having((list) => list[0].id, 'id', '00001')
              .having((list) => list[0].folderId, 'folderId', '00001')
              .having((list) => list[0].back, 'back', 'じゃ')
              .having((list) => list[0].front, 'front', 'see ya'));
    });
    test('UpdateCard negative testing', () async {
      when(_cardRepository.update(any)).thenAnswer((_) async => 0);
      CardModel _card3 =
          CardModel(_card1.id, _card1.folderId, _card2.front, _card2.back, 1);
      await _viewmodel.updateCard(index: 0, card: _card3);
      verify(_cardRepository.update(_card3)).called(1);
      expect(
          _viewmodel.cardItems,
          isA<List<CardModel>>()
              .having((list) => list, 'isNotNull', isNotNull)
              .having((list) => list.length, 'length', 1)
              .having((list) => list[0].id, 'id', '00001')
              .having((list) => list[0].folderId, 'folderId', '00001')
              .having((list) => list[0].back, 'back', 'こんにちわ')
              .having((list) => list[0].front, 'front', 'hello'));
    });
    test('ReordreCard testing', () async {
      when(_cardRepository.bulkUpdate(any)).thenAnswer((_) async => 2);
      when(_cardRepository.create(any, any, any, 2,
              frontLang: captureAnyNamed('frontLang'),
              backLang: captureAnyNamed('backLang')))
          .thenAnswer((_) async => _card2);
      await _viewmodel.addCard(
          _card2.front, _card2.back, _card2.frontLang, _card2.backLang);
      await _viewmodel.reorderCard(1, 0);
      verify(_cardRepository.bulkUpdate(any)).called(1);
      expect(
          _viewmodel.cardItems,
          isA<List<CardModel>>()
              .having((list) => list.length, 'length', 2)
              .having((list) => list[0].id, 'id', '00002'));
    });
  });
}
