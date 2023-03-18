import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../API/GetAPI.dart';
import '../../Cookie/SalveKey.dart';
import '../../provider/Providers.dart';

class BarPH extends StatefulWidget {
  Changes change;

  BarPH({required this.change});

  @override
  State<BarPH> createState() => _BarPHState();
}

class _BarPHState extends State<BarPH> {
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
          return Container(
            padding: EdgeInsets.only(left: 10),
            child: SfLinearGauge(
              minimum: 0,
              maximum: 14,
              markerPointers: [
                LinearShapePointer(
                  value: DataDay.isEmpty ? 0 : DataDay.last[1],
                ),
                LinearWidgetPointer(
                  value: DataDay.isEmpty ? 0 : DataDay.last[1],
                  child: Container(
                    width: 55,
                    height: 30,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Text(
                        "${DataDay.isEmpty ? 0 : DataDay.last[1]}",
                      ),
                    ),
                  ),
                  position: LinearElementPosition.outside,
                ),
              ],
              barPointers: [
                LinearBarPointer(
                    value: 14,
                    thickness: 10,
                    //Apply linear gradient
                    shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.redAccent, Colors.blueAccent])
                        .createShader(bounds)),
              ],
            ),
          );
        }));
  }
}
