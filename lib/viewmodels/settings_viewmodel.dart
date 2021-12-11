import 'package:flutter/material.dart';
import 'package:flash_card/models/preference_model.dart';
import 'package:flash_card/models/repositories/preference_repository.dart';
import 'package:flash_card/utilities/stt.dart';

class SettingsViewModel extends ChangeNotifier {
  PreferenceModel _preference = PreferenceModel();

  final Stt _stt = Stt();
  final Map<String, String> _langItems = {};

  SettingsViewModel() {
    get();
    initSpeech();
  }

  PreferenceModel get preference => _preference;
  Map<String, String> get langItems => _langItems;

  void initSpeech() async {
    await _stt.initSpeechState().then((value) {
      for (var e in _stt.localeNames) {
        _langItems[e.localeId] = e.name;
      }
      notifyListeners();
    });
  }

  void update(PreferenceModel pref) {
    PreferenceRepository.update(pref).then((value) {
      notifyListeners();
    });
  }

  void get() {
    PreferenceRepository.get().then((value) {
      _preference = value!;
      notifyListeners();
    });
  }
}
