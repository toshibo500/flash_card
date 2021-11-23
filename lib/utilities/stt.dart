import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class Stt {
  bool _hasSpeech = false;
  final bool _logEvents = true;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String _currentLocaleId = '';
  // ignore: unused_field
  List<LocaleName> localeNames = [];
  final SpeechToText _speech = SpeechToText();

  Stt._();
  static final Stt instance = Stt._();
  factory Stt() => instance;

  get isListening => _speech.isListening;

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
        localeNames = await _speech.locales();
        var systemLocale = await _speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
    }
    _speech.errorListener = onError;
    _speech.statusListener = onStatus;
  }

  Future<void> startListening(
      {required Function(SpeechRecognitionResult) onResult,
      Function(double)? onSoundLevelChange,
      String localeId = ''}) async {
    _logEvent('start listening');
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    _speech.listen(
        onResult: onResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: localeId != '' ? localeId : _currentLocaleId,
        onSoundLevelChange: onSoundLevelChange,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
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
