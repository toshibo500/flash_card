import 'package:flutter/material.dart';

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
  final TextEditingController _frontCtl = TextEditingController(text: "初期値");
  final TextEditingController _backCtl = TextEditingController(text: "初期値");
  final List<bool> _isListening = [false, false];
  late AnimationController _animationControler;
  late Animation<Color?> _animationColor;
  final ColorTween _tweenColor = ColorTween(
      begin: Colors.black.withOpacity(0.0), end: Colors.black.withOpacity(0.2));

  @override
  void initState() {
    super.initState();
    initAnimation();
  }

  void initAnimation() {
    _animationControler =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animationColor = _tweenColor.animate(_animationControler);
    _animationColor.addListener(() => setState(() => {}));
  }

  @override
  void dispose() {
    _animationControler.dispose();
    super.dispose();
  }

  void startListening(int index) {
    setState(() {
      _isListening[0] = false;
      _isListening[1] = false;
      _isListening[index] = true;
    });
    _animationControler.repeat(reverse: true);
  }

  void stopListening(int index) {
    setState(() {
      _isListening[index] = false;
    });
    _animationControler.stop();
  }

  @override
  Widget build(BuildContext context) {
    _frontCtl.text = widget.front ?? "";
    _backCtl.text = widget.back ?? "";
    return AlertDialog(
        title: const Text("Create a card"),
        content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          _buildTextField(_frontCtl, 'front'),
          Container(alignment: Alignment.topLeft, child: _buildMicIcon(0)),
          _buildTextField(_backCtl, 'back'),
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
                    context, [_frontCtl.text, _backCtl.text]);
              }),
        ]);
  }

  Container _buildMicIcon(int index) {
    return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: _isListening[index]
                    ? _animationColor.value as Color
                    : Colors.black.withOpacity(0.0))
          ],
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
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
