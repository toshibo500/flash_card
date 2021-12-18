/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  final int fontSize;

  const BarChart(
      {Key? key,
      required this.seriesList,
      required this.animate,
      required this.fontSize})
      : super(key: key);

  /// Creates a [BarChart] with sample data and no transition.
  factory BarChart.show(List<dynamic> data,
      [int fontSize = 9, bool animate = false]) {
    return BarChart(
      seriesList: _createData(data),
      animate: animate,
      fontSize: fontSize,
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
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<dynamic, String>> _createData(List<dynamic> data) {
    return [
      charts.Series<dynamic, String>(
        id: 'SampleData',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (dynamic list, _) => list.date,
        measureFn: (dynamic list, _) => list.time,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class SampleData {
  final String date;
  final int time;

  SampleData(this.date, this.time);
}
