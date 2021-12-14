import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/test_result_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

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

  static const TextStyle scoreLTextStyle = TextStyle(
    color: Colors.indigoAccent,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 32.0,
  );
  static const TextStyle scoreSTextStyle = TextStyle(
    color: Colors.indigoAccent,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 13.0,
  );

  @override
  Widget build(BuildContext context) {
    var _testResultViweModel = Provider.of<TestResultViewModel>(context);
    // 結果表示
    Widget _result = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(L10n.of(context)!.result),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '${_testResultViweModel.test.numberOfCorrectAnswers}/${_testResultViweModel.test.numberOfQuestions}',
                  style: scoreLTextStyle,
                ),
                Text(
                  L10n.of(context)!.numberOfCorrect +
                      '/' +
                      L10n.of(context)!.numberOfQuestion,
                  style: scoreSTextStyle,
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_testResultViweModel.test.numberOfCorrectAnswers / _testResultViweModel.test.numberOfQuestions * 100}',
                      style: scoreLTextStyle,
                    ),
                    const Text(
                      '%',
                      style: scoreSTextStyle,
                    )
                  ],
                ),
                Text(
                  L10n.of(context)!.accuracyRate,
                  style: scoreSTextStyle,
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getTestingTime(_testResultViweModel),
                      style: scoreLTextStyle,
                    ),
                    Text(
                      L10n.of(context)!.sec,
                      style: scoreSTextStyle,
                    )
                  ],
                ),
                Text(
                  L10n.of(context)!.duration,
                  style: scoreSTextStyle,
                ),
              ],
            )
          ],
        ),
      ],
    );
    // 結果表示一覧
    Widget _resultList = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(L10n.of(context)!.resultList),
        Container(
          height: 400,
          child: ListView.builder(
            itemCount: _testResultViweModel.testList.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(_testResultViweModel
                      .testList[index].numberOfCorrectAnswers
                      .toString() +
                  '/' +
                  _testResultViweModel.testList[index].numberOfQuestions
                      .toString());
            },
          ),
        )
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(_testResultViweModel.book.title),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => {
              Navigator.popUntil(context, ModalRoute.withName('/'))
            }, // 一旦rootに戻す。bookPageに戻す場合はrooting方法を再検討。単純に/bookPageとすると真っ黒画面。参考:https://blog.dalt.me/2616
          ),
        ),
        body: Column(children: [_result, _resultList]));
  }

  String _getTestingTime(TestResultViewModel model) {
    DateTime from = model.test.startedAt;
    DateTime? to = model.test.endedAt;
    return to != null ? '${to.difference(from).inSeconds}' : '';
  }
}
