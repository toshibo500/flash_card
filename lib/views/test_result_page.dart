import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      String rate = '${(noOfCorrect / noOfQuestion * 100).round()}';
      return rate + (addUnit ? '%' : '');
    }

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
    for (var item in _testResultViweModel.testList) {
      String title = '${item.numberOfCorrectAnswers}/${item.numberOfQuestions}';
      String startAt = DateFormat('M/d HH:mm').format(item.startedAt);
      String accuracyRate =
          _getSccuracyRate(item.numberOfCorrectAnswers, item.numberOfQuestions);
      String duration = _getDifferenceInSec(item.startedAt, item.endedAt!);
      _resultRows.add(DataRow(cells: <DataCell>[
        _getDataCell(startAt),
        _getDataCell(title, Alignment.center),
        _getDataCell(accuracyRate),
        _getDataCell(duration),
      ]));
    }
    TextStyle _dataTableColumnStyle =
        const TextStyle(fontStyle: FontStyle.italic, fontSize: 12);
    // 結果一覧テーブル
    Widget _resultTable = DataTable(
      horizontalMargin: 10,
      columnSpacing: 35,
      headingRowHeight: 30,
      dataRowHeight: 45,
      columns: [
        DataColumn(
          label: Text(
            L10n.of(context)!.dateTime,
            style: _dataTableColumnStyle,
            textAlign: TextAlign.center,
          ),
        ),
        DataColumn(
          label: Text(
            L10n.of(context)!.numberOfCorrect +
                '/' +
                L10n.of(context)!.numberOfQuestion,
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

    // 検索結果一覧
    Widget _resultList = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [Text(L10n.of(context)!.resultList), _resultTable],
    );

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
        body: Column(children: [_result, _resultList]));
  }
}
