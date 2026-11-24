// Esse arquivo vai utilizar o ApiClient para fazer login e cadastro.

// imports
import '../../../core/network/api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  // Cadastro
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return await _apiClient.post(
      '/api/auth/register',
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _apiClient.post(
      '/api/auth/login',
      body: {''
        'email': email,
        'password': password,
      },
    );
  }
}
