import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:collection/collection.dart';

import '../../API/GetAPI.dart';
import '../../Cookie/SalveKey.dart';
import '../../provider/Providers.dart';

class BarTDS extends StatefulWidget {
  Changes change;

  BarTDS({required this.change});

  @override
  State<BarTDS> createState() => _BarTDSState();
}

List<double> media = [];

class _BarTDSState extends State<BarTDS> {
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
          return Container(
            padding: EdgeInsets.only(left: 10),
            child: SfLinearGauge(
              minimum: 0,
              maximum: 3000,
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
                    value: DataDay.isEmpty ? 0 : DataDay.last[1],
                    //Change the color
                    color: Colors.redAccent)
              ],
            ),
          );
        }));
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final int x;
  final double y;
}
