/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AnswerTimeChart extends StatelessWidget {
  final List<charts.Series<AnswerTime, String>> seriesList;
  final bool animate;
  final int fontSize;
  final String title;

  @override
  const AnswerTimeChart(
      {Key? key,
      required this.seriesList,
      required this.animate,
      required this.fontSize,
      required this.title})
      : super(key: key);

  /// Creates a [BarChart] with sample data and no transition.
  factory AnswerTimeChart.show(
      {required List<AnswerTime> data,
      int fontSize = 9,
      bool animate = false,
      String title = 'Answer Time'}) {
    return AnswerTimeChart(
      seriesList: _createData(data),
      animate: animate,
      fontSize: fontSize,
      title: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: fontSize, // size in Pts.
        ),
      )),
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: fontSize, // size in Pts.
        ),
      )),
      behaviors: [
        charts.ChartTitle(title,
            titleStyleSpec: charts.TextStyleSpec(
              fontSize: 12,
              fontFamily: 'Roboto',
              color: charts.ColorUtil.fromDartColor(Colors.black54),
            ),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 12),
      ],
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
