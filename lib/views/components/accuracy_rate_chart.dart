/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AccuracyRateChart extends StatelessWidget {
  final List<charts.Series<AccuracyRate, String>> seriesList;
  final bool animate;

  const AccuracyRateChart(
      {Key? key, required this.seriesList, required this.animate})
      : super(key: key);

  /// Creates a [BarChart] with sample data and no transition.
  factory AccuracyRateChart.show(List<AccuracyRate> data) {
    return AccuracyRateChart(
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
