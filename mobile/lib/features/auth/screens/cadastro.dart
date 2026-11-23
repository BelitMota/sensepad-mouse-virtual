// Página de cadastro

// imports
import 'package:flutter/material.dart';

// imports de comunicação com a api
import '../../../core/network/api_client.dart';
import '../../../core/network/api_config.dart';
import '../services/auth_service.dart';

// import das cores
import '../../../shared/theme/app_theme.dart';

// conexão com a tela de login
import './login.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {

// ======================================================================== //
// Configurações

  late final AuthService _authService = AuthService(
    ApiClient(baseUrl: ApiConfig.baseUrl),
  );

  // controla os campos de texto
  final TextEditingController _usernameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // validação do formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //visibilidade das senhas
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // carregamento do cadastro
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
        color: Theme.of(context)
            .colorScheme
            .onSurface
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

      // campo normal
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),

      // campo selecionado
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
// func de cadastro em si

  Future<void> _register() async {

    // verifica se passou pela validação
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // está carregando?
    setState(() {
      _isLoading = true;
    });

    try {

      // envia os dados
      await _authService.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
        ),
      );

      // levando o usuário para a tela de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

    } catch (error) {

      if (!mounted) return;

      // msg de erro
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

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

                    // título
                    Text(
                      'Cadastrar-se',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // campo nome
                    TextFormField(
                      controller: _usernameController,

                      decoration: _inputDecoration(
                        hint: 'Username',
                        icon: Icons.person_outline,
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe um nome de usuário.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

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

                        if (!value.contains('@') ||
                            !value.contains('.')) {
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
                          return 'Informe uma senha.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),


                    // campo confirmar senha
                    TextFormField(
                      controller: _confirmPasswordController,

                      obscureText: _obscureConfirmPassword,

                      decoration: _inputDecoration(
                        hint: 'Confirmar senha',
                        icon: Icons.lock_outline,

                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),

                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirme sua senha.';
                        }

                        if (value != _passwordController.text) {
                          return 'As senhas não coincidem.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 28),


                    // btn cadastro
                    Center(
                      child: SizedBox(
                        width: 220,
                        height: 48,

                        child: FilledButton(
                          onPressed: _isLoading ? null : _register,

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
                              : const Text('Cadastrar-se'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),


                    // link pro login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          'Já tem uma conta? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurface,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginScreen(),
                              ),
                            );
                          },

                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),

                          child: const Text(
                            'Faça Login!',
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
