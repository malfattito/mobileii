import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'scenes/login/login_factory.dart';

void main() {
  // The scene is built once, here. Building it inside CarteiraApp.build would
  // create a new, empty ViewModel on every rebuild (a hot reload, for one),
  // while the text fields kept showing what had been typed.
  runApp(CarteiraApp(home: LoginFactory.make()));
}

class CarteiraApp extends StatelessWidget {
  const CarteiraApp({required this.home, super.key});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carteira Digital',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: home,
    );
  }
}
