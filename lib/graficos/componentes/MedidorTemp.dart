import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../API/GetAPI.dart';
import '../../Cookie/SalveKey.dart';
import '../../provider/Providers.dart';

class MedidorTemp extends StatefulWidget {
  Changes change;

  MedidorTemp({required this.change});

  @override
  State<MedidorTemp> createState() => _MedidorTempState();
}

class _MedidorTempState extends State<MedidorTemp> {
  List DataDay = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: GetValues(),
        builder: ((context, snapshot) {
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
              child: SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(minimum: -10, maximum: 50, ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: -10,
                      endValue: 0,
                      color: Colors.blue,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 0,
                      endValue: 15,
                      color: Color(0xff39d9fd),
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 15,
                      endValue: 30,
                      color: Color(0xff98fd39),
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 30,
                      endValue: 50,
                      color: Colors.red,
                      startWidth: 10,
                      endWidth: 10)
                ], pointers: <GaugePointer>[
                  NeedlePointer(
                      value: DataDay.isEmpty
                          ? 0
                          : DataDay.last[1])
                ], annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Container(
                          child: Text(
                              '${DataDay.isEmpty ? 0 : DataDay.last[1]}°C',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))),
                      angle: 90,
                      positionFactor: 0.5)
                ])
              ]),
            );
        }));
  }
}
