import 'package:app/Pages/BluetoothPage.dart';
import 'package:flutter/material.dart';

import '../Cookie/SalveKey.dart';
import '../Pages/HomePage.dart';
import '../Pages/Reflesh.dart';
import '../Pages/Tutorial.dart';
import '../Pages/WifiPage.dart';
import '../provider/Providers.dart';

Drawer menu(BuildContext context, Changes changes) {
  return Drawer(
    child: SafeArea(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(children: [
              Image.asset(
                  width: 100,
                  height: 100,
                  'assets/LGP2.png'),
              Text("LINTECH SOLUÇÕES"),
            ],),
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: NetworkImage(_imageUrl), fit: BoxFit.cover)),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home"),
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => MyHomePage()));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ));
                        Navigator.pop(context);
                      }),
                  ListTile(
                   enabled: false,
                      leading: Icon(Icons.water_drop_outlined),
                      title: Text("Picina"),
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => Wifi()));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Wifi(),
                            ));
                        Navigator.pop(context);
                      }),
                  ListTile(
                      enabled: false,
                      leading: Icon(Icons.water_drop_outlined),
                      title: Text("Lagoa"),
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => SplashPage(
                                  page: Bluetooth(),
                                )));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashPage(
                                page: Bluetooth(),
                              ),
                            ));
                        Navigator.pop(context);
                      }),
                  ListTile(
                      enabled: false,
                      leading: Icon(Icons.water_drop_outlined),
                      title: Text("Aquário"),
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => SplashPage(
                                  page: Bluetooth(),
                                )));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashPage(
                                page: Bluetooth(),
                              ),
                            ));
                        Navigator.pop(context);
                      }),
                  ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("Sair"),
                      onTap: () {
                        PrefsService.logout();
                        ServiceFilter.logout();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => SplashPage(
                                  page: OnboardingScreen(),
                                )));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashPage(
                                page: OnboardingScreen(),
                              ),
                            ));
                        Navigator.pop(context);
                      })
                ],
              )),
        ],
      ),
    ),
  );
}
