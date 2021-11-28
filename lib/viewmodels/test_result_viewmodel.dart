import 'package:flash_card/models/repositories/test_repository.dart';
import 'package:flash_card/models/test_model.dart';
import 'package:flutter/material.dart';

class TestResultViewModel extends ChangeNotifier {
  late String _id;
  late TestModel _test;
  TestModel get test => _test;

  TestResultViewModel(String id) {
    _id = id;
    _getTest();
  }

  void _getTest() {
    TestRepository.get(_id).then((value) {
      _test = value!;
      notifyListeners();
    });
  }
}
