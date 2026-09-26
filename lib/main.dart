import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'scenes/login/login_factory.dart';

void main() {
  runApp(const CarteiraApp());
}

class CarteiraApp extends StatelessWidget {
  const CarteiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carteira Digital',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: LoginFactory.make(),
    );
  }
}
