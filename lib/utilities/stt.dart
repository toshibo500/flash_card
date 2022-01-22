import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class Stt {
  bool _hasSpeech = false;
  final bool _logEvents = kDebugMode;
  double minSoundLevel = 20;
  double maxSoundLevel = -20;
  String _currentLocaleId = '';
  // ignore: unused_field
  List<LocaleName> localeNames = [];
  final SpeechToText _speech = SpeechToText();

  // デバイス判定
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  Stt._();
  static final Stt instance = Stt._();
  factory Stt() => instance;

  get isListening => _speech.isListening;
  get hasSpeech => _hasSpeech;
  get currentLocaleId => _currentLocaleId;
  set(String currentLocaleId) => _currentLocaleId = currentLocaleId;
  String get currentLocaleName => _hasSpeech
      ? localeNames
          .firstWhere((element) => element.localeId == _currentLocaleId,
              orElse: () => LocaleName('', ''))
          .name
      : '';

  /// This initializes SpeechToText. That only has to be done
  /// once per application, though calling it again is harmless
  /// it also does nothing. The UX of the sample app ensures that
  /// it can only be called once.
  Future<void> initSpeechState(
      {Function(SpeechRecognitionError)? onError,
      Function(String)? onStatus}) async {
    if (!_hasSpeech) {
      _logEvent('Initialize');
      _hasSpeech = await _speech.initialize(
        debugLogging: false,
      );
      if (_hasSpeech) {
        // localeはiOSに合わせる
        localeNames = _convertLocaleIds(await _speech.locales());
//        localeNames = await _speech.locales();
        var systemLocale = await _speech.systemLocale();
        // localeはiOSに合わせる
        if (systemLocale == null) {
          _currentLocaleId = '';
        } else {
          _currentLocaleId = _convertLocaleIdToiOS(systemLocale).localeId;
        }
      }
    }
    _speech.errorListener = onError;
    _speech.statusListener = onStatus;
  }

  List<LocaleName> _convertLocaleIds(List<LocaleName> locales) {
    if (isAndroid) {
      return locales.map((e) => _convertLocaleIdToiOS(e)).toList();
    } else {
      return locales;
    }
  }

  LocaleName _convertLocaleIdToiOS(LocaleName locale) {
    return LocaleName(
        locale.localeId.replaceFirst(RegExp('_'), '-'), locale.name);
  }

  String _convertLocaleIdToAndroid(String localeId) {
    return localeId.replaceFirst(RegExp('-'), '_');
  }

  Future<void> startListening(
      {required Function(SpeechRecognitionResult) onResult,
      Function(double)? onSoundLevelChange,
      String? localeId}) async {
    _logEvent('start listening');
    _currentLocaleId = localeId ?? _currentLocaleId;
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    _speech.listen(
        onResult: onResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 30),
        partialResults: true,
        // アプリではiOS形式で統一して保持するため、deviceがAndroidの場合はstart直前にAndroidに戻す
        localeId: isAndroid
            ? _convertLocaleIdToAndroid(_currentLocaleId)
            : _currentLocaleId,
        onSoundLevelChange: onSoundLevelChange,
        cancelOnError: true,
        listenMode: ListenMode.deviceDefault);
  }

  void stopListening() {
    _logEvent('stop');
    _speech.stop();
  }

  void cancelListening() {
    _logEvent('cancel');
    _speech.cancel();
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      // ignore: avoid_print
      print('$eventTime $eventDescription');
    }
  }
}
