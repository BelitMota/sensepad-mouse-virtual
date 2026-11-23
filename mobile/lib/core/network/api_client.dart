// Esse arquivo faz a comunicação com a api

// imports
import 'dart:convert'; // permite converter JSON para estruturas do dart(map) e vice-versa
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
  });

  // Envia uma requisição POST para a API.
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    final Uri url = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 15));

    // Converte a resposta JSON para um Map do Dart.
    final dynamic decoded = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : <String, dynamic>{};

    final Map<String, dynamic> data =
        decoded is Map<String, dynamic>
            ? decoded
            : {'data': decoded};

    // Verifica se a requisição foi bem-sucedida.
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    // Obtém a mensagem de erro retornada pela API.
    final String message =
        data['message']?.toString() ??
        data['erro']?.toString() ??
        'Erro na comunicação com a API.';

    throw Exception(message);
  }
}
