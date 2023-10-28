import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prj_dev_mobile/Opcoes.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Opcoes()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Cor de fundo da splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.food_bank, // Substitua pelo ícone desejado
              size: 64,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Calcule as calorias do alimentos e seu IMC',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white, // Cor do texto
              ),
              textAlign: TextAlign
                  .center, // Define o alinhamento do texto como central
            ),
          ],
        ),
      ),
    );
  }
}
