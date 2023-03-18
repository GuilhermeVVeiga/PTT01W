import 'package:flutter/material.dart';

import '../Cookie/SalveKey.dart';

class Changes with ChangeNotifier {
  String key;
  Changes({required this.key}) {
    initialState();
  }
  void initialState() {
    syncDataWithProvider();
  }


  DateTime _day = DateTime.now().add(Duration(days: 0));
  DateTime get day => _day;


  Future syncDataWithProvider() async {
    if (await ServiceFilter.Filter(key, "day") != null) {
      DateTime day =
      DateTime.parse(await ServiceFilter.Filter(key, "day"));
      _day = day;
    }
    notifyListeners();
  }


  void Time(DateTime day) {
    _day = day;
    ServiceFilter.save(key, "day", day.toString());
    notifyListeners();
  }
}
