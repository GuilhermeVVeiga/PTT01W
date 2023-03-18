import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';

import '../API/GetAPI.dart';
import 'HomePage.dart';
import 'Reflesh.dart';

class LoginApi extends StatefulWidget {
  @override
  State<LoginApi> createState() => _LoginApiState();
}

class _LoginApiState extends State<LoginApi> {
  String ticket = '';
  TextEditingController nomeController = TextEditingController();
  List<String> tickets = [];

  readQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );
    setState(() => nomeController.text = code != '-1' ? code : 'Não validado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            reverse: true,
            child: Center(
              child: Column(

                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: Image.asset(
                      'assets/LGP2.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                      Padding(padding: EdgeInsets.symmetric(vertical:10),child:Text(
                        textAlign: TextAlign.center,
                        "Conecte-se com sua chave de acesso localizada no exterior do dispositivo.",
                        style: TextStyle(fontSize: 15),
                      ),),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          autofillHints: [AutofillHints.email],
                          autofocus: false,
                          controller: nomeController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Chave do Servidor',
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 245, 125, 13),
                                  width: 1.2),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.orange))),
                          backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 245, 125, 13),
                          ),
                        ),
                        onPressed: () async {
                          bool alright =
                          await AnswerVariable(nomeController.text);
                          if (alright) {
                            context.go('/home');
                          }
                        },
                        icon: const Icon(Icons.input),
                        label: const Text('Entrar'),
                      ),

                    ],)
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(color: Colors.blue)))),
                        onPressed: readQRCode,
                        icon: const Icon(Icons.qr_code),
                        label: const Text('QR CODE'),
                      ),
                    ],)
                  ),
                ],
              ),
            )));
  }
}
