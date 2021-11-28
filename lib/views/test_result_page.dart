import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/test_result_viewmodel.dart';

class TestResultPage extends StatelessWidget {
  const TestResultPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TestResultViewModel(id),
      child: const Scaffold(body: _TestResultPage()),
    );
  }
}

class _TestResultPage extends StatelessWidget {
  const _TestResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _testResultViweModel = Provider.of<TestResultViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => {
              Navigator.popUntil(context, ModalRoute.withName('/'))
            }, // 一旦rootに戻す。bookPageに戻す場合はrooting方法を再検討。単純に/bookPageとすると真っ黒画面。参考:https://blog.dalt.me/2616
          ),
        ),
        body: Column(
          children: const [
            Expanded(child: Text('aaa')),
          ],
        ));
  }
}
