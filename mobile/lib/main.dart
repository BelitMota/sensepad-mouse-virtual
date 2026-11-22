
import 'package:flutter/material.dart';
import 'features/home/screens/home.dart';
import './shared/theme/app_theme.dart';

void main() {
  runApp(const SensePadApp());
}

class SensePadApp extends StatelessWidget {
  const SensePadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SensePad',
      theme: AppTheme.lightTheme,       // <-- Tema Claro
      darkTheme: AppTheme.darkTheme,    // <-- Tema Escuro
      themeMode: ThemeMode.system,      // <-- Muda sozinho conforme o celular
      home: const HomeScreen(),
    );
  }
}
