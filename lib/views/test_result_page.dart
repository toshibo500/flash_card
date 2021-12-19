import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/test_result_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/views/components/accuracy_rate_chart.dart';
import 'package:flash_card/views/components/answer_time_chart.dart';

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
    fontSize: 42.0,
  );
  static const TextStyle scoreSTextStyle = TextStyle(
    color: Colors.indigoAccent,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 13.0,
  );
  static const TextStyle titleTextStyle = TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    letterSpacing: 1,
    fontSize: 18.0,
  );

  static const TextStyle _dataTableColumnStyle = TextStyle(
      color: Colors.black54, fontStyle: FontStyle.italic, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    var _testResultViweModel = Provider.of<TestResultViewModel>(context);

    String _getDifferenceInSec(DateTime from, DateTime? to,
        [bool addUnit = true]) {
      String unit = addUnit ? L10n.of(context)!.sec : '';
      return to != null ? '${to.difference(from).inSeconds}$unit' : 'N/A';
    }

    String _getTestingTime(TestResultViewModel model) {
      DateTime from = model.test.startedAt;
      DateTime? to = model.test.endedAt;
      return _getDifferenceInSec(from, to, false);
    }

    String _getSccuracyRate(int noOfCorrect, int noOfQuestion,
        [bool addUnit = true]) {
      if (noOfQuestion == 0) return '';
      String rate = '${(noOfCorrect / noOfQuestion * 100).round()}';
      return rate + (addUnit ? '%' : '');
    }

    // 結果表示
    Widget _result = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              L10n.of(context)!.result,
              style: titleTextStyle,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_testResultViweModel.test.numberOfCorrectAnswers}',
                      style: scoreLTextStyle,
                    ),
                    Text(
                      '/${_testResultViweModel.test.numberOfQuestions}',
                      style: scoreSTextStyle,
                    )
                  ],
                ),
                Text(
                  L10n.of(context)!.numberOfCorrect,
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
                      _getSccuracyRate(
                          _testResultViweModel.test.numberOfCorrectAnswers,
                          _testResultViweModel.test.numberOfQuestions,
                          false),
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

    // DataCell作成
    DataCell _getDataCell(String txt,
        [AlignmentGeometry align = Alignment.centerRight]) {
      return DataCell(Container(alignment: align, child: Text(txt)));
    }

    // 結果表示リスト
    List<DataRow> _resultRows = [];
    _testResultViweModel.testList.asMap().forEach((int key, var item) {
      String title = '${item.numberOfCorrectAnswers}/${item.numberOfQuestions}';
      String startAt = DateFormat('M/d HH:mm').format(item.startedAt);
      String accuracyRate =
          _getSccuracyRate(item.numberOfCorrectAnswers, item.numberOfQuestions);
      String duration = _getDifferenceInSec(item.startedAt, item.endedAt);
      _resultRows.add(DataRow(cells: <DataCell>[
        _getDataCell((key + 1).toString()),
        _getDataCell(startAt),
        _getDataCell(title, Alignment.center),
        _getDataCell(accuracyRate),
        _getDataCell(duration),
      ]));
    });

    // 結果一覧テーブル
    Widget _resultTable = DataTable(
      horizontalMargin: 10,
      columnSpacing: 25,
      headingRowHeight: 30,
      dataRowHeight: 45,
      columns: [
        const DataColumn(
          label: Text(
            'No',
            style: _dataTableColumnStyle,
            textAlign: TextAlign.center,
          ),
        ),
        DataColumn(
          label: Text(
            L10n.of(context)!.dateTime,
            style: _dataTableColumnStyle,
            textAlign: TextAlign.center,
          ),
        ),
        DataColumn(
          label: Text(
            L10n.of(context)!.numberOfCorrect,
            style: _dataTableColumnStyle,
          ),
        ),
        DataColumn(
          label: Text(
            L10n.of(context)!.accuracyRate,
            style: _dataTableColumnStyle,
          ),
        ),
        DataColumn(
          label: Text(
            L10n.of(context)!.duration,
            style: _dataTableColumnStyle,
          ),
        ),
      ],
      rows: _resultRows,
    );

    // 結果一覧ボタン
    Widget _resultListBtn = Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/testResultListPage',
              arguments: _testResultViweModel.book.id);
        },
        child: Text(L10n.of(context)!.seeMore),
      ),
    );

    // 検索結果一覧
    Widget _resultList = SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_resultTable, _resultListBtn],
        ));

    // 正解率グラフ
    final List<AccuracyRate> accRateData = [];
    _testResultViweModel.testList.asMap().forEach((int key, var item) {
      // String startAt = DateFormat('M/d\nHH:mm').format(item.startedAt);
      String startAt = (key + 1).toString();
      String accuracyRate = _getSccuracyRate(
          item.numberOfCorrectAnswers, item.numberOfQuestions, false);
      accRateData.add(AccuracyRate(startAt, int.parse(accuracyRate)));
    });
    Widget accRateChart = Column(children: [
      SizedBox(
          height: 170,
          width: 180,
          child: AccuracyRateChart.show(
            data: accRateData,
            title: L10n.of(context)!.accuracyRateChart,
          ))
    ]);

    // 解答時間グラフ
    final List<AnswerTime> ansTimeData = [];
    _testResultViweModel.testList.asMap().forEach((int key, var item) {
      // String startAt = DateFormat('M/d\nHH:mm').format(item.startedAt);
      String startAt = (key + 1).toString();
      int ansTime = item.endedAt!.difference(item.startedAt).inSeconds;
      ansTimeData.add(AnswerTime(startAt, ansTime));
    });
    Widget ansTimeChart = Column(children: [
      SizedBox(
          height: 170,
          width: 180,
          child: AnswerTimeChart.show(
            data: ansTimeData,
            title: L10n.of(context)!.answerTimeChart,
          ))
    ]);

    // Scaffold
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
        body: Column(children: [
          Card(
              margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _result)),
          Card(
              margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    L10n.of(context)!.resultList,
                    style: titleTextStyle,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [accRateChart, ansTimeChart]))
              ])),
          Card(
              margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: _resultList)),
        ])
//      body: Center(child: SimpleBarChart.withSampleData()),
        );
  }
}
