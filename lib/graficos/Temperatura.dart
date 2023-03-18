import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../API/GetAPI.dart';
import '../Cookie/SalveKey.dart';
import '../provider/Providers.dart';

class TemperatureGraph extends StatefulWidget {
  Changes change;

  TemperatureGraph({required this.change});

  @override
  State<TemperatureGraph> createState() => _TemperatureGraphState();
}

class _TemperatureGraphState extends State<TemperatureGraph> {
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
          Data = snapshot.data![2];
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
        return Container(
            child: Center(
                child: Container(
                    child: SfCartesianChart(
                        tooltipBehavior: TooltipBehavior(enable: true),
                        title: ChartTitle(text: "Temperatura da água (°C)"),
                        primaryXAxis: CategoryAxis(
                          borderColor: Colors.white,
                          isVisible: false,
                          minimum: 0,
                        ),
                        primaryYAxis: NumericAxis(),
                        series: [
              LineSeries<dynamic, dynamic>(
                  markerSettings: MarkerSettings(isVisible: true),
                  dataSource: DataDay,
                  xValueMapper: (dynamic data, _) => data[0],
                  yValueMapper: (dynamic data, _) => data[1]),
              ColumnSeries<dynamic, dynamic>(
                  name: 'Temperatura',
                  color: Colors.transparent,
                  dataSource: DataDay,
                  xValueMapper: (dynamic data, _) => data[0],
                  yValueMapper: (dynamic data, _) => data[1]),
            ]))));
    });
  }
}
