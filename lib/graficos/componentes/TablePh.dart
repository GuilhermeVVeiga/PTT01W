import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../API/GetAPI.dart';
import '../../provider/Providers.dart';

class TablePH extends StatefulWidget {
  Changes change;

  TablePH({required this.change});

  @override
  State<TablePH> createState() => _TablePHState();
}

class _TablePHState extends State<TablePH> {
  List<double> media = [];
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
          media.clear();
          if (Data.isNotEmpty)
            Data.forEach((element) {
              if (DateTime.parse(element[0]).day == widget.change.day.day &&
                  DateTime.parse(element[0]).month == widget.change.day.month &&
                  DateTime.parse(element[0]).year == widget.change.day.year) {
                DataDay.add(element);
                media.add(element[1]);
              }
            });
      return Table(
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Colors.grey,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          verticalInside: BorderSide(
            color: Colors.grey,
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),
        children: [
          _criarLinhaTable("Mínimo, Máximo, Média, Último valor"),
          _criarLinhaTable(
              "${media.isEmpty ? 0 : media.min}, ${media.isEmpty ? 0 : media.max >10? 10 :media.max},"
              "${media.isEmpty ? 0 : media.average.toStringAsFixed(2)},"
              "${DataDay.isEmpty ? 0 : DataDay.last[1]} "),
        ],
      );
    }));
  }

  _criarLinhaTable(String listaNomes) {
    return TableRow(
      children: listaNomes.split(',').map((name) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(fontSize: 10.5),
          ),
          padding: EdgeInsets.all(8.0),
        );
      }).toList(),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final int x;
  final double y;
}
