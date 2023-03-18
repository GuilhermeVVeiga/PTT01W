import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  String imagem;
  String titulo;
  String texto;
  Widget? button;

  CustomSlider({required this.imagem, required this.titulo, required this.texto , this.button});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 100),
          Image.asset(
            imagem,
            height: 250,
            width: 250,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 12),
          button!,
        ],
      ),
    );
  }
}