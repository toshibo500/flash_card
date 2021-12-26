/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AccuracyRateChart extends StatelessWidget {
  final List<charts.Series<AccuracyRate, String>> seriesList;
  final bool animate;
  final int fontSize;
  final String title;

  const AccuracyRateChart(
      {Key? key,
      required this.seriesList,
      required this.animate,
      required this.fontSize,
      required this.title})
      : super(key: key);

  factory AccuracyRateChart.show(
      {required List<AccuracyRate> data,
      int fontSize = 9,
      bool animate = false,
      String title = 'Accurecy Rate'}) {
    return AccuracyRateChart(
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
        labelJustification: charts.TickLabelJustification.inside,
        labelStyle: charts.TextStyleSpec(
          fontSize: fontSize,
          color: charts.ColorUtil.fromDartColor(Theme.of(context).hintColor),
        ),
      )),
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: fontSize, // size in Pts.
          color: charts.ColorUtil.fromDartColor(Theme.of(context).hintColor),
        ),
      )),
      behaviors: [
        charts.ChartTitle(title,
            titleStyleSpec: charts.TextStyleSpec(
              fontSize: 12,
              fontFamily: 'Roboto',
              color:
                  charts.ColorUtil.fromDartColor(Theme.of(context).hintColor),
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
