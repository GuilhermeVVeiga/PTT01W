
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContainersBase extends StatefulWidget {

  final Widget graph;
  const ContainersBase({Key? key, required this.graph}) : super(key: key);

  @override
  _ContainersBase createState() => _ContainersBase();
}

class _ContainersBase extends State<ContainersBase> {



  @override
  Widget build(BuildContext context) {
    double padding = 10;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(padding),
      child: widget.graph,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
      ),
    );
  }
}
