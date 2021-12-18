import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flash_card/viewmodels/test_result_list_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TestResultListPage extends StatelessWidget {
  const TestResultListPage({Key? key, required this.bookId}) : super(key: key);
  final String bookId;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TestResultListViewModel(bookId),
      child: const Scaffold(body: _TestResultListPage()),
    );
  }
}

class _TestResultListPage extends StatelessWidget {
  const _TestResultListPage({Key? key}) : super(key: key);

  static const TextStyle _dataTableColumnStyle = TextStyle(
      color: Colors.black54, fontStyle: FontStyle.italic, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    var _testResultListViweModel =
        Provider.of<TestResultListViewModel>(context);

    String _getDifferenceInSec(DateTime from, DateTime? to,
        [bool addUnit = true]) {
      String unit = addUnit ? L10n.of(context)!.sec : '';
      return to != null ? '${to.difference(from).inSeconds}$unit' : 'N/A';
    }

    String _getSccuracyRate(int noOfCorrect, int noOfQuestion,
        [bool addUnit = true]) {
      if (noOfQuestion == 0) return '';
      String rate = '${(noOfCorrect / noOfQuestion * 100).round()}';
      return rate + (addUnit ? '%' : '');
    }

    // DataCell作成
    DataCell _getDataCell(String txt,
        [AlignmentGeometry align = Alignment.centerRight]) {
      return DataCell(Container(alignment: align, child: Text(txt)));
    }

    // 結果表示リスト
    List<DataRow> _resultRows = [];
    for (var item in _testResultListViweModel.testList) {
      String title = '${item.numberOfCorrectAnswers}/${item.numberOfQuestions}';
      String startAt = DateFormat('M/d HH:mm').format(item.startedAt);
      String accuracyRate =
          _getSccuracyRate(item.numberOfCorrectAnswers, item.numberOfQuestions);
      String duration = _getDifferenceInSec(item.startedAt, item.endedAt);
      _resultRows.add(DataRow(cells: <DataCell>[
        _getDataCell(startAt),
        _getDataCell(title, Alignment.center),
        _getDataCell(accuracyRate),
        _getDataCell(duration),
      ]));
    }

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
    Widget _resultList = SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_resultTable],
        ));

    // Scaffold
    return Scaffold(
        appBar: AppBar(
          title: Text(_testResultListViweModel.book.title),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () async {
                if (await confirm(
                  context,
                  title: const Text('Confirm'),
                  content: const Text('Would you like to remove?'),
                  textOK: const Text('Yes'),
                  textCancel: const Text('No'),
                )) {
                  _testResultListViweModel.deleteByBook();
                  Fluttertoast.showToast(msg: "done!");
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Card(
              margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: _resultList)),
        )
        //      body: Center(child: SimpleBarChart.withSampleData()),
        );
  }
}
