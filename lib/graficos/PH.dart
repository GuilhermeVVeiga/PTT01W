import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../API/GetAPI.dart';
import '../Cookie/SalveKey.dart';
import '../provider/Providers.dart';

class PhGraph extends StatefulWidget {
  Changes change;

  PhGraph({required this.change});

  @override
  State<PhGraph> createState() => _PhGraphState();
}

class _PhGraphState extends State<PhGraph> {
  List DataDay = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: GetValues(),
        builder: (context, snapshot) {
            List Data = [];
            if (snapshot.hasData) {
              Data = snapshot.data![0];
            } else {
              Data = [];
            }
            DataDay.clear();
            if (Data.isNotEmpty)
            Data.forEach((element) {
              if (DateTime.parse(element[0]).day == widget.change.day.day &&
                  DateTime.parse(element[0]).month == widget.change.day.month &&
                  DateTime.parse(element[0]).year == widget.change.day.year) {
                DataDay.add(element);
              }
            });
            return Center(
                child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    title: ChartTitle(text: "PH da água"),
                    primaryXAxis: CategoryAxis(
                      borderColor: Colors.white,
                      isVisible: false,
                      minimum: 0,
                    ),
                    primaryYAxis: NumericAxis(),
                    series: [
                  // Renders line chart
                  LineSeries<dynamic, dynamic>(
                      markerSettings: MarkerSettings(isVisible: true),
                      dataSource: DataDay,
                      xValueMapper: (dynamic data, _) => data[0],
                      yValueMapper: (dynamic data, _) => data[1]),
                  ColumnSeries<dynamic, dynamic>(
                      name: 'PH',
                      color: Colors.transparent,
                      dataSource: DataDay,
                      xValueMapper: (dynamic data, _) => data[0],
                      yValueMapper: (dynamic data, _) => data[1]),
                ]));
        });
  }
}
