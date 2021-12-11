import 'package:flutter/material.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';

class BookViewModel extends ChangeNotifier {
  bool _editMode = false;
  BookModel _selectedBook = BookModel('', '', '', '', 0);
  List<CardModel> _cardList = [];
  List<CardModel> get items => _cardList;

  PreferenceModel _preference = PreferenceModel();
  PreferenceModel get preference => _preference;

  BookViewModel(BookModel selectedBook) {
    this.selectedBook = selectedBook;
    getAll(_selectedBook.id);
    getPreference();
  }

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }

  get selectedBook => _selectedBook;
  set selectedBook(book) {
    _selectedBook = book;
  }

  void add(String front, String back) async {
    CardModel? item = await CardRepository.create(
        selectedBook.id, front, back, _cardList.length + 1);
    if (item != null) {
      _cardList.add(item);
      notifyListeners();
    }
  }

  void remove(int index) async {
    int res = await CardRepository.delete(_cardList[index].id);
    if (res > 0) {
      _cardList.removeAt(index);
      notifyListeners();
    }
  }

  void update(
      {required int index,
      String? bookId,
      required String front,
      required String back,
      required int sequence}) async {
    String _id = _cardList[index].id;
    String _folderId = bookId ?? _cardList[index].bookId;
    CardModel row = CardModel(_id, _folderId, front, back, sequence);
    int res = await CardRepository.update(row);
    if (res > 0) {
      _cardList[index] = row;
      notifyListeners();
    }
  }

  void getAll(String bookId) async {
    _cardList = await CardRepository.getAll(bookId);
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) async {
    final CardModel item = _cardList.removeAt(oldIndex);
    _cardList.insert(newIndex, item);
    await CardRepository.bulkUpdate(_cardList);
    notifyListeners();
  }

  void getPreference() {
    PreferenceRepository.get().then((value) {
      _preference = value!;
    });
    notifyListeners();
  }
}
