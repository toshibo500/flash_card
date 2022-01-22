import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class Tts {
  Tts._();
  static Tts? _instance;
  factory Tts() {
    _instance ??= Tts._();
    return _instance!;
  }

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.4;
  bool isCurrentLanguageInstalled = false;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  bool _isInitialized = false;

  initTts() {
    if (_isInitialized) return;
    _isInitialized = true;

    flutterTts = FlutterTts();
    _setAwaitOptions();
    if (isAndroid) {
      _getDefaultEngine();
    }
    flutterTts.setStartHandler(() {
      if (kDebugMode) {
        print("Playing");
      }
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      if (kDebugMode) {
        print("Complete");
      }
      ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      if (kDebugMode) {
        print("Cancel");
      }
      ttsState = TtsState.stopped;
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        if (kDebugMode) {
          print("Paused");
        }
        ttsState = TtsState.paused;
      });

      flutterTts.setContinueHandler(() {
        if (kDebugMode) {
          print("Continued");
        }
        ttsState = TtsState.continued;
      });
    }

    flutterTts.setErrorHandler((msg) {
      if (kDebugMode) {
        print("error: $msg");
      }
      ttsState = TtsState.stopped;
    });
  }

  // ignore: unused_element
  Future<dynamic> _getLanguages() => flutterTts.getLanguages;

  // ignore: unused_element
  Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      if (kDebugMode) {
        print(engine);
      }
    }
  }

  Future setLanguage(String language) async {
    await flutterTts.setLanguage(language);
    if (isAndroid) {
      bool ret = await flutterTts.isLanguageInstalled(language);
      isCurrentLanguageInstalled = ret;
    }
  }

  Future speak(String voiceText) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    if (isIOS) {
      await flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);
    }
    if (voiceText.isNotEmpty) {
      await flutterTts.speak(voiceText);
    }
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }

  Future pause() async {
    var result = await flutterTts.pause();
    if (result == 1) ttsState = TtsState.paused;
  }
}
