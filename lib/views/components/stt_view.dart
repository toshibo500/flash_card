import 'package:flutter/material.dart';

class SttView extends StatefulWidget {
  const SttView({Key? key}) : super(key: key);
  @override
  _SttView createState() => _SttView();
}

class _SttView extends State<SttView> {
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
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).backgroundColor,
      child: const Center(
          child: Text(
        "I'm listening...",
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
    );
  }
}
