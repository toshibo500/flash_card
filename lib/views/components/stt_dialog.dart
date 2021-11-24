import 'package:flutter/material.dart';
import 'package:flash_card/utilities/stt.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:blinking_text/blinking_text.dart';

class SttDialog extends StatefulWidget {
  const SttDialog({Key? key, required this.txtCtl}) : super(key: key);
  final TextEditingController txtCtl;
  @override
  _SttDialog createState() => _SttDialog();
}

class _SttDialog extends State<SttDialog> with TickerProviderStateMixin {
  final bool _isListening = false;
  // Stt _stt = Stt();
  late String _lastwords;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            children: [
              _buildMicIcon(),
              const BlinkText(
                "Listening...",
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            height: 140,
            child: const Text('abcd efg jjkakka'),
          ),
        ]),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop<String>(context, ''),
          ),
          TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop<String>(context, '');
              }),
        ]);
  }

  Container _buildMicIcon() {
    return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.mic_rounded),
          color: Colors.blue,
        ));
  }
}

Future showSttDialog(
    {required BuildContext context,
    TransitionBuilder? builder,
    required TextEditingController txtCtl}) {
  Widget dialog = SttDialog(txtCtl: txtCtl);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}
