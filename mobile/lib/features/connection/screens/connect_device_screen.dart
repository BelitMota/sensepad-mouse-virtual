
import 'package:flutter/material.dart';

import '../../../core/network/connection_manager.dart';
import '../../mouse/screens/mouse_screen.dart';

class ConnectDeviceScreen extends StatefulWidget {
  const ConnectDeviceScreen({super.key});

  @override
  State<ConnectDeviceScreen> createState() =>
      _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState extends State<ConnectDeviceScreen> {

// ============================================================ //
// Conexão

  final ConnectionManager _connection = ConnectionManager();

  // controla o campo de endereço IP
  final TextEditingController _ipController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const int _port = 5000;

  // carregamento
  bool _connecting = false;


// ============================================================ //
// Conexão com o desktop

  Future<void> _connectDevice() async {

    // verifica se o endereço IP é válido
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_connecting) return;

    setState(() {
      _connecting = true;
    });

    try {

      // endereço IP do usuário
      final String ip = _ipController.text.trim();

      await _connection.connect(ip, _port);
      if (!mounted) return;

      // direcionamento para a tela do mouse
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const MouseScreen(),
        ),
      );

    } catch (error) {
      _connection.disconnect();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível conectar: $error',
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          _connecting = false;
        });
      }
    }
  }


// ============================================================ //
//  Controladores

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

// ============================================================ //
// Interface

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // cabeçalho
      appBar: AppBar(
        title: const Text('Conectar dispositivo'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // ================================================== //
                // Titulo + descrição

                Icon(
                  Icons.computer,
                  size: 65,
                  color: colors.primary,
                ),

                const SizedBox(height: 18),

                Text(
                  'Conectar ao computador',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Informe o endereço IP do computador '
                  'para estabelecer a conexão.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.65),
                  ),
                ),

                const SizedBox(height: 32),


                // ================================================== //
                // campo pro endereço ip
                Text(
                  'Endereço IP',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _ipController,

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Ex.: 192.168.1.100',
                    prefixIcon: const Icon(Icons.wifi),
                    filled: true,
                    fillColor: Theme.of(context).brightness ==
                            Brightness.dark
                        ? const Color(0xFF1A2436)
                        : const Color(0xFFEEF2FF),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: colors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),

                  // verifica se o IP foi preenchido certo
                  validator: (value) {
                    final ip = value?.trim() ?? '';

                    if (ip.isEmpty) {
                      return 'Informe o endereço IP do computador.';
                    }

                    final parts = ip.split('.');

                    if (parts.length != 4) {
                      return 'Endereço IP inválido.';
                    }

                    for (final part in parts) {
                      final number = int.tryParse(part);

                      if (number == null ||
                          number < 0 ||
                          number > 255) {
                        return 'Endereço IP inválido.';
                      }
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),


                // ================================================== //
                // Mini tutorial pra encontrar o ip da sua maquina
                Container(
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.25),
                    ),
                  ),

                  child: ExpansionTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: colors.primary,
                    ),

                    title: const Text(
                      'Não sabe encontrar seu IP?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    subtitle: const Text(
                      'Veja o tutorial passo a passo.',
                      style: TextStyle(fontSize: 12),
                    ),

                    childrenPadding: const EdgeInsets.fromLTRB(
                      16, 0, 16, 18,
                    ),

                    children: [

                      // Primeiro passo
                      _tutorialStep(
                        number: '1',
                        title: 'Abra o Prompt de Comando',
                        description:
                            'Pressione Windows + R, digite cmd '
                            'e pressione Enter.',
                      ),

                      const Divider(),

                      // Segundo passo
                      _tutorialStep(
                        number: '2',
                        title: 'Digite o comando ipconfig',
                        description:
                            'No terminal que abriu, digite ipconfig '
                            'e pressione Enter.',
                      ),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'ipconfig',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Terceiro passo
                      _tutorialStep(
                        number: '3',
                        title: 'Encontre o Endereço IPv4',
                        description:
                            'Procure a conexão Wi-Fi que está '
                            'sendo utilizada e localize o campo '
                            'Endereço IPv4.',
                      ),

                      const SizedBox(height: 10),

                      // Quarto passo
                      _tutorialStep(
                        number: '4',
                        title: 'Informe o endereço no SensePad',
                        description:
                            'Copie o número encontrado e digite '
                            'no campo de endereço IP acima.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),


                // ================================================== //
                // rede wifi aviso
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: colors.primary,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        'O celular e o computador precisam estar '
                        'conectados à mesma rede Wi-Fi.',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),


                // ================================================== //
                // Botão de conexão
                SizedBox(
                  height: 52,

                  child: FilledButton.icon(
                    onPressed: _connecting ? null : _connectDevice,

                    icon: _connecting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.link),

                    label: Text(
                      _connecting
                          ? 'Conectando...'
                          : 'Conectar',
                    ),

                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


// ============================================================ //
//  Tutorial Components

  Widget _tutorialStep({
    required String number,
    required String title,
    required String description,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Número do passo.
          CircleAvatar(
            radius: 15,
            backgroundColor: colors.primary,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Descrição do passo.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
