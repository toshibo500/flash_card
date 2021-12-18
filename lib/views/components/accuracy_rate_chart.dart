/// Bar chart example
import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AccuracyRateChart extends StatelessWidget {
  final List<charts.Series<AccuracyRate, String>> seriesList;
  final bool animate;
  final int fontSize;

  const AccuracyRateChart(
      {Key? key,
      required this.seriesList,
      required this.animate,
      required this.fontSize})
      : super(key: key);

  factory AccuracyRateChart.show(List<AccuracyRate> data,
      [int fontSize = 9, bool animate = false]) {
    return AccuracyRateChart(
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
          fontSize: fontSize, //size in Pts.
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
  static List<charts.Series<AccuracyRate, String>> _createData(
      List<AccuracyRate> data) {
    return [
      charts.Series<AccuracyRate, String>(
        id: 'AccuracyRate',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AccuracyRate list, _) => list.date,
        measureFn: (AccuracyRate list, _) => list.rate,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class AccuracyRate {
  final String date;
  final int rate;

  AccuracyRate(this.date, this.rate);
}
