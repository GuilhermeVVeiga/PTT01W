import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../API/GetAPI.dart';
import '../provider/Providers.dart';

class tdsGraph extends StatefulWidget {
  Changes change;

  tdsGraph({required this.change});

  @override
  State<tdsGraph> createState() => _tdsGraphState();
}

class _tdsGraphState extends State<tdsGraph> {
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
              Data = snapshot.data![1];
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
                    primaryXAxis: CategoryAxis(
                      borderColor: Colors.white,
                      isVisible: false,
                      minimum: 0,
                    ),
                    primaryYAxis: NumericAxis(),
                    title: ChartTitle(text: "TDS da água (ppm)"),
                    series:[
                  ColumnSeries<dynamic, dynamic>(
                      name: 'TDS',
                      color: Colors.transparent,
                      dataSource: DataDay,
                      xValueMapper: (dynamic data, _) => data[0],
                      yValueMapper: (dynamic data, _) => data[1]),
                  // Renders line chart
                  LineSeries<dynamic, dynamic>(
                      // dataLabelSettings: DataLabelSettings(
                      //     useSeriesColor: true,
                      //     isVisible: true
                      // ),
                      markerSettings: MarkerSettings(isVisible: true),
                      dataSource: DataDay,
                      xValueMapper: (dynamic data, _) => data[0],
                      yValueMapper: (dynamic data, _) => data[1])
                ]));
        });
  }
}
