import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/Menu.dart';
import '../Date/Date.dart';
import '../Widgets/ContainerPerson.dart';
import '../graficos/PH.dart';
import '../graficos/TDS.dart';
import '../graficos/Temperatura.dart';
import '../graficos/componentes/MedidorTemp.dart';
import '../graficos/componentes/TablePh.dart';
import '../graficos/componentes/TableTDS.dart';
import '../graficos/componentes/TableTemp.dart';
import '../graficos/componentes/barPh.dart';
import '../graficos/componentes/barTDS.dart';
import '../provider/Providers.dart';
import 'Tutorial.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Changes changes = Changes(key: "MyHomePage");
  Timer? _timer;

  final GlobalKey<ScaffoldState> keyMenu = GlobalKey(); // Create a key
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print("as");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => changes,
        ),
      ],
      child: Scaffold(
        key: keyMenu,

        endDrawer: SafeArea(
          child: Drawer(
              child: Container(
            child: Date(change: changes),
          )),
        ),
        drawer: menu(context, changes),
        appBar: AppBar(
          centerTitle: true,
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    keyMenu.currentState!.openEndDrawer();
                  },
                  child: Icon(Icons.date_range),
                )),
            // Container(
            //     margin: EdgeInsets.only(right: 10),
            //     child: InkWell(
            //       onTap: () {
            //         Navigator.of(context).push(new MaterialPageRoute(
            //             builder: (BuildContext context) => OnboardingScreen()));
            //       },
            //       child: Icon(Icons.info_outline),
            //     )),
          ],
          title: Text("PTT-01W"),
        ),
        body: SingleChildScrollView(child: Center(
            child: Consumer<Changes>(builder: ((context, notiFil, child) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhGraph(change: changes),
                BarPH(change: changes),
                ContainersBase(
                  graph: TablePH(
                    change: changes,
                  ),
                ),
                SizedBox(height: 20),
                tdsGraph(change: changes),
                BarTDS(change: changes),
                ContainersBase(
                  graph: TableTDS(
                    change: changes,
                  ),
                ),
                SizedBox(height: 20),
                TemperatureGraph(change: changes),
                MedidorTemp(change: changes),
                ContainersBase(
                  graph: TableTemp(
                    change: changes,
                  ),
                ),
              ],
            ),
          );
        })))),
      ),
    );
  }

  void myShowDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Container(
              height: 300,
              width: 300,
              color: Colors.black,
              child: MultiProvider(providers: [
                ChangeNotifierProvider(
                  create: (context) => changes,
                ),
              ], child: Date(change: changes))),
        );
      },
    );
  }

  _criarLinhaTable(String listaNomes) {
    return TableRow(
      children: listaNomes.split(',').map((name) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(fontSize: 20.0),
          ),
          padding: EdgeInsets.all(8.0),
        );
      }).toList(),
    );
  }
}
