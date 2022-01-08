import 'package:flutter/material.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';

class DrawerMenuViewModel extends ChangeNotifier {
  PreferenceModel _preference = PreferenceModel();

  DrawerMenuViewModel() {
    get();
  }

  PreferenceModel get preference => _preference;

  void update(PreferenceModel pref) {
    PreferenceRepository.update(pref).then((value) {
      notifyListeners();
    });
  }

  void get() {
    PreferenceRepository.get().then((value) {
      _preference = value;
      notifyListeners();
    });
  }
}
