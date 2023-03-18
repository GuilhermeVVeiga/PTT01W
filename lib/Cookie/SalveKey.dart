import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static final String _key = 'key';

  static save(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _key,
      jsonEncode({
        "key": key,
        "isAuth": true,
      }),
    );
  }
  Future<bool> isAuth() async {
    var prefs = await SharedPreferences.getInstance();
    var jsonResult = prefs.getString(_key);
    if(jsonResult != null){
      var mapUser = jsonDecode(jsonResult);
      return mapUser['isAuth'];
    }
    return false;
  }
  static Future<String> GetKey() async {
    var prefs = await SharedPreferences.getInstance();
    var jsonResult = prefs.getString(_key);
    String components = '';
    if (jsonResult != null) {
      Map mapUser =  jsonDecode(prefs.getString('key')!);
      components = await mapUser['key'];
      return components;
    }
    return components;
  }
  static logout () async{
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}

class ServiceFilter {
  static final String _keys = 'keys';

  static salvekeys(String key) async{
    var prefs = await SharedPreferences.getInstance();
    print(prefs.getString(_keys));
    if (prefs.getString(_keys) != null) {
      final Map mapUser = jsonDecode(prefs.getString(_keys)!);
      mapUser[key] = key;
      prefs.setString(
        _keys,
        jsonEncode(mapUser),
      );
    }else{
      prefs.setString(
        _keys,
        jsonEncode({
          key: key,
        }),
      );
    }
  }

  static save(String key, String param, String value) async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString(key) != null) {
      //print(prefs.getString(key));

      final Map mapUser = jsonDecode(prefs.getString(key)!);
      mapUser[param] = value;
      prefs.setString(
        key,
        jsonEncode(mapUser),
      );
    } else {
      salvekeys(key);
      prefs.setString(
        key,
        jsonEncode({
          param: value,
        }),
      );
    }
  }

  static Future<dynamic> Filter(String key, String param) async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) != null) {
      Map mapUser = jsonDecode(prefs.getString(key)!);
      var info = await mapUser[param];
      return info;
    }
    return null;
  }

  static logout() async {
    var prefs = await SharedPreferences.getInstance();
    final Map mapUser = jsonDecode(prefs.getString(_keys)!);
    mapUser.forEach((key, value) {
      prefs.remove(key);
    });
  }
}
