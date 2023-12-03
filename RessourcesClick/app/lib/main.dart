import 'package:flutter/material.dart';
import 'pages/ressourcesPage.dart';

void main() {
  runApp(const MyClickerGame());
}

class MyClickerGame extends StatelessWidget {
  const MyClickerGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ressources Click',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const RessourcesPage(),
    );
  }
}
