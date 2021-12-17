/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AnswerTimeChart extends StatelessWidget {
  final List<charts.Series<AnswerTime, String>> seriesList;
  final bool animate;

  const AnswerTimeChart(
      {Key? key, required this.seriesList, required this.animate})
      : super(key: key);

  /// Creates a [BarChart] with sample data and no transition.
  factory AnswerTimeChart.show(List<AnswerTime> data) {
    return AnswerTimeChart(
      seriesList: _createData(data),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<AnswerTime, String>> _createData(
      List<AnswerTime> data) {
    return [
      charts.Series<AnswerTime, String>(
        id: 'AnswerTime',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AnswerTime list, _) => list.date,
        measureFn: (AnswerTime list, _) => list.time,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class AnswerTime {
  final String date;
  final int time;

  AnswerTime(this.date, this.time);
}
