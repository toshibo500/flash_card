import 'package:flutter/material.dart';
import 'package:flash_card/utilities/stt.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class InputCardDialog extends StatefulWidget {
  const InputCardDialog(
      {Key? key, String this.front = '', String this.back = ''})
      : super(key: key);
  final String? front, back;

  @override
  _InputCardDialog createState() => _InputCardDialog();
}

class _InputCardDialog extends State<InputCardDialog>
    with TickerProviderStateMixin {
  final List<TextEditingController> _textCtl = [
    TextEditingController(text: ''),
    TextEditingController(text: '')
  ];
  final List<bool> _isListening = [false, false];
  // late AnimationController _animationControler;
  // late Animation<Color?> _animationColor;
  // final ColorTween _tweenColor = ColorTween(
  //    begin: Colors.black.withOpacity(0.0), end: Colors.black.withOpacity(0.2));

  Stt stt = Stt();
  late String _lastwords;

  @override
  void initState() {
    super.initState();
    initAnimation();
    stt.initSpeechState(onError: onSttError, onStatus: onSttStatus);

    _textCtl[0].text = widget.front!;
    _textCtl[1].text = widget.back!;
  }

  @override
  void dispose() {
    // _animationControler.dispose();
    super.dispose();
  }

  void initAnimation() {
    // _animationControler =
    //    AnimationController(vsync: this, duration: const Duration(seconds: 1));

    // _animationColor = _tweenColor.animate(_animationControler);
    // _animationColor.addListener(() => setState(() => {}));
  }

  void onSttError(SpeechRecognitionError error) {
    // ignore: avoid_print
    // print('Received listener status: $error, listening: ${stt.isListening}');
  }

  void onSttStatus(String status) {
    // ignore: avoid_print
    // print('Received listener status: $status, listening: ${stt.isListening}');
    if (status == 'done') {
      int index = _isListening.indexOf(true);
      setState(() {
        _textCtl[index].text += _lastwords;
        _lastwords = '';
        _isListening[index] = false;
      });
    }
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    // ignore: avoid_print
    print(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');

    if (result.finalResult) {
      _lastwords = result.recognizedWords;
    }
  }

  void startListening(int index) {
    // _animationControler.repeat(reverse: true);
    stt.startListening(onResult: resultListener);
    FocusScope.of(context).unfocus();
    setState(() {
      _isListening[0] = false;
      _isListening[1] = false;
      _isListening[index] = true;
    });
  }

  void stopListening(int index) {
    // _animationControler.stop();
    stt.stopListening();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Create a card"),
        content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          _buildTextField(_textCtl[0], 'front'),
          Container(alignment: Alignment.topLeft, child: _buildMicIcon(0)),
          _buildTextField(_textCtl[1], 'back'),
          Container(alignment: Alignment.topLeft, child: _buildMicIcon(1)),
        ])),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop<List<String>>(context, []),
          ),
          TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop<List<String>>(
                    context, [_textCtl[0].text, _textCtl[1].text]);
              }),
        ]);
  }

  Container _buildMicIcon(int index) {
    return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
/*         decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: _isListening[index]
                    ? _animationColor.value as Color
                    : Colors.black.withOpacity(0.0))
          ],
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ), */
        child: _isListening[index]
            ? IconButton(
                onPressed: () {
                  stopListening(index);
                },
                icon: const Icon(Icons.mic_rounded),
                color: Colors.blue,
              )
            : IconButton(
                onPressed: () {
                  startListening(index);
                },
                icon: const Icon(Icons.mic_off_rounded),
                color: Colors.grey,
              ));
  }

  SizedBox _buildTextField(TextEditingController txtClt, String hintText) {
    return SizedBox(
        height: 80,
        child: TextField(
          controller: txtClt,
          decoration: InputDecoration(hintText: hintText),
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 4,
        ));
  }
}

Future showInputCardDialog(
    {required BuildContext context,
    TransitionBuilder? builder,
    String front = "",
    String back = ""}) {
  Widget dialog = InputCardDialog(front: front, back: back);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}
