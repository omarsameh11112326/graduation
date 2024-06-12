import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ServiceProviderPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ServiceProviderPieChart(this.seriesList, {required this.animate});

  factory ServiceProviderPieChart.withData(Map<String, int> data) {
    return ServiceProviderPieChart(
      _createData(data),
      animate: true,
    );
  }

  static List<charts.Series<ServiceProviderData, String>> _createData(
      Map<String, int> data) {
    final List<ServiceProviderData> dataList = data.entries
        .map((entry) => ServiceProviderData(entry.key, entry.value))
        .toList();

    return [
      charts.Series<ServiceProviderData, String>(
        id: 'ServiceProviders',
        domainFn: (ServiceProviderData providers, _) => providers.type,
        measureFn: (ServiceProviderData providers, _) => providers.count,
        data: dataList,
        labelAccessorFn: (ServiceProviderData row, _) =>
            '${row.type}: ${row.count}',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [charts.ArcLabelDecorator()],
      ),
    );
  }
}

class ServiceProviderData {
  final String type;
  final int count;

  ServiceProviderData(this.type, this.count);
}
