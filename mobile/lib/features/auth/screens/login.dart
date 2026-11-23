// Página de login

// imports
import 'package:flutter/material.dart';

// imports de comunicação com a api
import '../../../core/network/api_client.dart';
import '../../../core/network/api_config.dart';
import '../services/auth_service.dart';

// import das cores
import '../../../shared/theme/app_theme.dart';

// conexão com a tela de cadastro
import './cadastro.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

// ======================================================================== //
// Configurações

  // cria o serviço responsável pelo login
  late final AuthService _authService = AuthService(
    ApiClient(baseUrl: ApiConfig.baseUrl),
  );

  // controla os campos de texto
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  // controla a validação do formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // controla a visibilidade da senha
  bool _obscurePassword = true;

  // fala se o login está sendo processado
  bool _isLoading = false;


// ======================================================================== //
// Cores (vê se o aplicativo está no modo escuro)

  bool get _isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get _inputColor =>
      _isDark ? AppColors.darkInput : AppColors.lightInput;


// ======================================================================== //
// Decoração

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface
            .withValues(alpha: 0.55),
      ),
      suffixIcon: suffixIcon,

      filled: true,
      fillColor: _inputColor,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 15,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),
    );
  }


// ======================================================================== //
// func de login em si

  Future<void> _login() async {

    // verifica se passou pela validação
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // está carregando?
    setState(() {
      _isLoading = true;
    });

    try {

      // envia email e senha
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso!'),
        ),
      );

// A navegação para a tela da Home + armazenamento do JWT
    } catch (error) {

      if (!mounted) return;

      // Exibe o erro retornado pela API.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: AppColors.error,
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

// ======================================================================== //
// libera controladores definidos anteriormente

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }


// ======================================================================== //
// Interface

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 24,
            ),

            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 360,
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [

                    // logo
                    Image.asset(
                      'assets/images/logo_component_text.png',
                      width: 220,
                      height: 220,
                    ),

                    const SizedBox(height: 8),

                    // titulo
                    Text(
                      'Entrar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // campo email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,

                      decoration: _inputDecoration(
                        hint: 'Email',
                        icon: Icons.person_outline,
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe seu email.';
                        }

                        if (!value.contains('@')) {
                          return 'Informe um email válido.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // campo senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,

                      decoration: _inputDecoration(
                        hint: 'Senha',
                        icon: Icons.lock_outline,

                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),

                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe sua senha.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    // btn login
                    Center(
                      child: SizedBox(
                        width: 220,
                        height: 48,

                        child: FilledButton(
                          onPressed: _isLoading ? null : _login,

                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),

                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Entrar'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // link pro cadastro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ainda não tem uma conta? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurface,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },

                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),

                          child: const Text(
                            'Cadastre-se!',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
