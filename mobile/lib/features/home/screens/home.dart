
import 'package:flutter/material.dart';
import '../../connection/screens/connect_device_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Cores do tema atual (claro ou escuro)
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 140,
                  height: 140,
                ),

                const SizedBox(height: 16),

                // Nome do aplicativo
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sense',
                        style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: 'Pad',
                        style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Subtítulo
                Text(
                  'Seu computador na ponta dos dedos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.onSurface.withValues(alpha: 0.65),
                  ),
                ),

                const SizedBox(height: 40),

                // Botão de login
                FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConnectDeviceScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_2),
                  label: const Text('Login'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),

                const SizedBox(height: 14),

                // Botão de cadastro
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConnectDeviceScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Cadastrar-se'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(color: colors.primary),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),

                const SizedBox(height: 14),

                // Botão de convidado
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConnectDeviceScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.badge_outlined),
                  label: const Text('Entrar como convidado'),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.onSurface.withValues(alpha: 0.7),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
