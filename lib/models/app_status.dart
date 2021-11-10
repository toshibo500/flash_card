import 'package:flutter/material.dart';

class AppStatusModel extends ChangeNotifier {
  bool _editMode = false;

  bool get editMode => _editMode;
  set editMode(mode) {
    _editMode = mode;
    notifyListeners();
  }
}
