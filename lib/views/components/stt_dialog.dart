import 'package:flutter/material.dart';
import 'package:flash_card/utilities/stt.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SttDialog extends StatefulWidget {
  const SttDialog({Key? key, this.localeId}) : super(key: key);
  final String? localeId;
  @override
  _SttDialog createState() => _SttDialog();
}

class _SttDialog extends State<SttDialog> {
  final Stt _stt = Stt();
  String _lastwords = '';
  double _level = 0.0;
  Color _micColor = Colors.black;
  bool restart = false;
  double _withOpacity = 0.05;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSttError(SpeechRecognitionError error) {
    // ignore: avoid_print
    // print('Received listener status: $error, listening: ${_stt.isListening}');
  }

  void onSttStatus(String status) {
    // ignore: avoid_print
    print('Received listener status: $status, listening: ${_stt.isListening}');
    setState(() {
      if (status == 'done' && !_stt.isListening) {
        _level = 0.0;
        _withOpacity = .0;
        _micColor = Theme.of(context).disabledColor;
        if (restart) {
          startListening();
          restart = false;
        }
      } else {
        _withOpacity = .05;
        _micColor = Theme.of(context).textTheme.bodyText1!.color!;
      }
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    // ignore: avoid_print
    // print(
    // 'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    if (mounted) {
      setState(() {
        _lastwords = result.recognizedWords;
      });
    }
  }

  void startListening() async {
    await _stt.initSpeechState(onError: onSttError, onStatus: onSttStatus);
    if (_stt.hasSpeech) {
      await _stt.startListening(
          onResult: resultListener,
          onSoundLevelChange: soundLevelListener,
          localeId: widget.localeId!);
    }
    setState(() {
      _lastwords = '';
    });
  }

  void soundLevelListener(double level) {
    // ignore: avoid_print
    setState(() {
      _level = level;
    });
    // ignore: avoid_print
    // print('sound level $_level');
  }

  void stopListening() {
    // _animationControler.stop();
    _stt.stopListening();
  }

  void reStartListening() {
    // _animationControler.stop();
    if (_stt.isListening && _lastwords != '') {
      restart = true;
      stopListening();
    } else {
      startListening();
    }
  }

  String kanaToHira(String str) {
    return str.replaceAllMapped(RegExp("[ァ-ヴ]"),
        (Match m) => String.fromCharCode(m.group(0)!.codeUnitAt(0) - 0x60));
  }

  String hiraToKana(String str) {
    return str.replaceAllMapped(RegExp("[ぁ-ゔ]"),
        (Match m) => String.fromCharCode(m.group(0)!.codeUnitAt(0) + 0x60));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(
            _stt.currentLocaleName,
            style: const TextStyle(fontSize: 12.0),
          ),
          Container(
            alignment: Alignment.topLeft,
            height: 180,
            child: Text(_lastwords),
          ),
          _buildMicIcon(),
          _buildConvertIcon()
        ]),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          TextButton(
            child: Text(L10n.of(context)!.retry),
            onPressed: () => reStartListening(),
          ),
          TextButton(
            child: Text(L10n.of(context)!.cancel),
            onPressed: () {
              stopListening();
              Navigator.pop<String>(context, '');
            },
          ),
          TextButton(
              child: Text(L10n.of(context)!.ok),
              onPressed: () {
                stopListening();
                Navigator.pop<String>(context, _lastwords);
              }),
        ]);
  }

  Container _buildMicIcon() {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 1,
              spreadRadius: _level * 1.5,
              color: Colors.black.withOpacity(_withOpacity))
        ],
//        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.mic,
        ),
        color: _micColor,
        iconSize: 26,
        // ignore: avoid_returning_null_for_void
        onPressed: () => reStartListening(),
      ),
    );
  }

  Widget _buildConvertIcon() {
    return Visibility(
      visible: widget.localeId == 'ja-JP',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: const Text(
              'ひら->カナ',
              style: TextStyle(fontSize: 11),
            ),
            onPressed: () {
              setState(() {
                _lastwords = hiraToKana(_lastwords);
              });
            },
          ),
          TextButton(
            child: const Text(
              'カナ->ひら',
              style: TextStyle(fontSize: 11),
            ),
            onPressed: () {
              setState(() {
                _lastwords = kanaToHira(_lastwords);
              });
            },
          ),
        ],
      ),
    );
  }
}

Future showSttDialog(
    {required BuildContext context,
    TransitionBuilder? builder,
    String? localeId}) {
  Widget dialog = SttDialog(localeId: localeId!);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}
