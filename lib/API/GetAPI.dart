import 'package:app/Pages/Reflesh.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Cookie/SalveKey.dart';
import 'Jason.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> AnswerVariable(String key) async {
  var url = Uri.parse(
      'https://api.thingspeak.com/channels/1897693/feeds.json?api_key=${key}&results');
  var resposta = await http.get(
    url,
  );
  if (resposta.statusCode == 200) {
    PrefsService.save(key);
    return true;
  } else {
    return false;
  }
}

Future<List> GetValues() async {
  List ph = [];
  List tds = [];
  List temperatura = [];
  List three = [];
  final DateFormat formatter = DateFormat('MM-dd-yyyy');


  var url = Uri.parse(
      'https://api.thingspeak.com/channels/1897693/feeds.json?api_key=${Keys}&results');
  var resposta = await http.get(
    url,
  );
  Variables values = Variables.fromJson(jsonDecode(resposta.body));
  values.toJson().forEach((key, all) {
    if (key == 'feeds') {
      int size = all.length;
      for (int registre = 0; registre < size ; registre++) {
        var objetc = all[registre];

        var phString;
        var tdsString;
        var tempString;

        if(objetc['field1'] =='nan'){
          phString = '0.0';
          phString = double.parse(phString);
        }
        else{
          phString = double.parse(objetc['field1']);
        }
        if(objetc['field2'] =='nan'){
          tdsString = '0.0';
          tdsString = double.parse(tdsString);
        }
        else{
          tdsString = double.parse(objetc['field2']);
        }
        if(objetc['field3'] =='nan\r\n'){
          tempString = '0.0';
          tempString = double.parse(tempString);
        }
        else{
          tempString = double.parse(objetc['field3']);
        }
        assert(phString is double);
        assert(tdsString is double);
        assert(tempString is double);
        DateTime datavalues =  DateTime.parse(objetc['created_at'].replaceAll('-', '').replaceAll('Z', '').replaceAll(':', '')).subtract(const Duration(hours: 3));
        String datetime1 = DateFormat("dd/MM/yy HH:mm:ss").format(datavalues);

        ph.add([datavalues.toString(), phString]);
        tds.add([datavalues.toString(), tdsString]);
        temperatura.add([datavalues.toString(), tempString]);
        //data = data + 1;

      }
      three.add(ph);
      three.add(tds);
      three.add(temperatura);
    }
  });
  if (resposta.statusCode == 200) {
    return three;
  } else {
    return [];
  }
}