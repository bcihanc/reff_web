import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class MyChart extends StatelessWidget {
  final List<Series> seriesList;

  MyChart(this.seriesList);

  @override
  Widget build(BuildContext context) {
    return seriesList == null
        ? Center(child: Text('no data'))
        : PieChart(seriesList,
            animate: false,
            defaultRenderer: ArcRendererConfig(
                arcWidth: 60, arcRendererDecorators: [ArcLabelDecorator()]));
  }
}

List<Series<SeriesModel<T>, String>> fromMapToChartModel<T>(Map<T, int> map) {
  if (map == null && map.isEmpty) return null;

  final data = <SeriesModel<T>>[];
  map.forEach((key, value) {
    if (value > 0) {
      final entry = SeriesModel<T>(label: key, amount: value);
      data.add(entry);
    }
  });

  if (data.isEmpty) return null;

  return [
    Series<SeriesModel<T>, String>(
        id: 'LABEL',
        domainFn: (model, _) => model.label.toString(),
        measureFn: (model, _) => model.amount,
        data: data,
        labelAccessorFn: (row, _) => '${row.label}: ${row.amount}',
        outsideLabelStyleAccessorFn: (model, _) =>
            TextStyleSpec(color: Color.white))
  ];
}

class SeriesModel<T> {
  SeriesModel({@required this.label, @required this.amount})
      : assert(label != null),
        assert(amount != null);

  final T label;
  final int amount;
}
