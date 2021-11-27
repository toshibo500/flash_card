import 'package:flutter/material.dart';
import 'package:flash_card/utilities/stt.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SttDialog extends StatefulWidget {
  const SttDialog({Key? key}) : super(key: key);
  @override
  _SttDialog createState() => _SttDialog();
}

class _SttDialog extends State<SttDialog> {
  final Stt _stt = Stt();
  String _lastwords = '';
  double _level = 0.0;
  Color _micColor = Colors.black;

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
    print('Received listener status: $error, listening: ${_stt.isListening}');
  }

  void onSttStatus(String status) {
    // ignore: avoid_print
    print('Received listener status: $status, listening: ${_stt.isListening}');
    setState(() {
      if (status == 'done') {
        _level = 0.0;
        _micColor = Colors.grey;
      } else {
        _micColor = Colors.black;
      }
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    // ignore: avoid_print
    print(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
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
          onResult: resultListener, onSoundLevelChange: soundLevelListener);
      setState(() {
        _lastwords = '';
      });
    }
  }

  void soundLevelListener(double level) {
    // ignore: avoid_print
    setState(() {
      _level = level;
    });
    // ignore: avoid_print
    print('sound level $_level');
  }

  void stopListening() {
    // _animationControler.stop();
    _stt.stopListening();
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
        ]),
        actions: [
          TextButton(
            child: const Text("Retry"),
            onPressed: () => startListening(),
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              stopListening();
              Navigator.pop<String>(context, '');
            },
          ),
          TextButton(
              child: const Text("OK"),
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
              color: Colors.black.withOpacity(.05))
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.mic,
        ),
        color: _micColor,
        iconSize: 26,
        // ignore: avoid_returning_null_for_void
        onPressed: () => startListening(),
      ),
    );
  }
}

Future showSttDialog(
    {required BuildContext context, TransitionBuilder? builder}) {
  Widget dialog = const SttDialog();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}
