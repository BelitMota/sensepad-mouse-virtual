// imports
import 'package:flutter/material.dart';
import 'features/welcome/screens/welcome.dart';
import './shared/theme/app_theme.dart';

// imports com a api
import 'core/network/api_client.dart';
import 'core/network/api_config.dart';


// ============================================================ //
// teste de comunicação

Future<void> testApiConnection() async {
  //cria o cliente
  final apiClient = ApiClient(
    baseUrl: ApiConfig.baseUrl,
  );

  try {
    // consulta o status da api
    final response = await apiClient.get('/api/status');

    debugPrint('API CONECTADA!');
    debugPrint('Resposta: $response');

  } catch (error) {
    debugPrint('ERRO AO CONECTAR COM A API: $error');
  }
}

void main() {
  runApp(const SensePadApp());
  testApiConnection();
}

class SensePadApp extends StatelessWidget {
  const SensePadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SensePad',
      
      // cores e tema
      theme: AppTheme.lightTheme,       // <-- Tema Claro
      darkTheme: AppTheme.darkTheme,    // <-- Tema Escuro
      themeMode: ThemeMode.system,      // <-- Muda sozinho conforme o celular

      home: const HomeScreen(),
    );
  }
}
