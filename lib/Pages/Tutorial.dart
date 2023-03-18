import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/Button.dart';
import '../Widgets/Link.dart';
import '../Widgets/Paginator.dart';
import '../Widgets/Slides.dart';
import 'HomePage.dart';
import 'LoginAPI.dart';
import 'Reflesh.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Future<void>? _launched;
  @override
  Widget build(BuildContext context) {
    final Uri toLaunch =
    Uri(scheme: 'http', host: '192.168.4.1', path: 'wifi');
    return Scaffold(
      body: SafeArea(
        child:
        Stack(children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            physics: ClampingScrollPhysics(),
            children: [
              CustomSlider(
                button: Container(),
                imagem: 'assets/wifi.jpeg',
                titulo: 'Primeiro passo: Conecte-se na rede do aparelho',
                texto:
                    'Após ligar o aparelho, verifique se o led vermelho está acesso, confirmado, você terá que se conectar na rede PTT-01W com a senha mostrada no exterior do dispositivo',
              ),
              CustomSlider(
                imagem: 'assets/rede.jpeg',
                titulo: 'Segundo passo: Conecte o dispositivo na sua rede Wi-fi',
                texto: 'Para conectar, pressione o botão abaixo e selecione a rede de sua preferência',
                button: ElevatedButton.icon(
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
                  onPressed: () => setState(() {
                    _launched = _launchInBrowser(toLaunch);
                  }),
                  icon: const Icon(Icons.wifi),
                  label: const Text('Acessar redes'),
                ),
              ),
              CustomSlider(
                button: Container(),
                imagem: 'assets/LGP2.png',
                titulo: 'Terceiro passo: entre com sua chave de acesso',
                texto: 'Com o led verde acesso, seu dispositivo já está em operação. Agora, digite ou scaneie o código QR CODE colado no seu dispositivo',
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _currentPage == 2
                    ? CustomButton(
                        titulo: _currentPage == 2 ? 'ENTRAR' : 'CONTINUAR',
                        irParaPaginaInicial: _currentPage == 2
                            ? irParaPaginaInicial
                            : proximoCard,
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomLink(
                  titulo: 'Pular tutorial',
                  irParaPaginaInicial: irParaPaginaInicial,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 170.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaginator(
                  page: _currentPage,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
  void irParaPaginaInicial() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SplashPage(page: LoginApi(),)));

    _setEstado();
  }

  void proximoCard() {
    _pageController.nextPage(
        duration: Duration(seconds: 1), curve: Curves.easeIn);
  }

  _setEstado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool ativo = prefs.getBool('ativo') ?? false;

    if (!ativo) {
      await prefs.setBool('ativo', true);
    }
  }
}

