
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/network/connection_manager.dart';
import '../models/pointer_event.dart';
import '../widgets/mouse_sidebar.dart';
import '../widgets/touchpad_area.dart';
import '../widgets/mouse_buttons.dart';

class MouseScreen extends StatefulWidget {
  const MouseScreen({super.key});

  @override
  State<MouseScreen> createState() => _MouseScreenState();
}

class _MouseScreenState extends State<MouseScreen> {
  final ConnectionManager _connection = ConnectionManager();

  final FocusNode _keyboardFocusNode = FocusNode();
  final TextEditingController _keyboardController =
      TextEditingController();

  late bool _connected;
  late String _status;

  @override
  void initState() {
    super.initState();

    // Verifica a conexão estabelecida pelo QR Code.
    _connected = _connection.isConnected;

    _status = _connected
        ? 'Conectado ao computador!'
        : 'Desconectado';

    // Força a orientação horizontal.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Envia o movimento do dedo.
  void _sendMovement(PointerMovement movement) {
    if (!_connected) return;

    _connection.sendMovement(movement);
  }

  // Pressiona o botão esquerdo para iniciar a seleção.
  void _sendStartDrag() {
    if (!_connected) return;

    _connection.sendStartDrag();
  }

  // Libera o botão esquerdo do mouse.
  void _sendEndDrag() {
    if (!_connected) return;

    _connection.sendEndDrag();
  }

  // Executa o clique direito.
  void _rightClick() {
    if (!_connected) return;

    _connection.sendRightClick();
  }

  // Executa um clique esquerdo simples.
  void _sendLeftClick() {
    if (!_connected) return;

    _connection.sendLeftClick();
  }

  // Abre o teclado nativo do Android.
  void _openKeyboard() {
    if (!_connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conecte-se ao computador primeiro.'),
        ),
      );
      return;
    }

    _keyboardFocusNode.requestFocus();
  }

  void _showDevelopment(String feature) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.construction,
          size: 38,
          color: Color(0xFF8CBFD4),
        ),
        title: const Text('Em desenvolvimento'),
        content: Text('$feature ainda está sendo desenvolvido.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Evita deixar o botão esquerdo pressionado.
    if (_connected) {
      _sendEndDrag();
    }

    _connection.disconnect();

    _keyboardController.dispose();
    _keyboardFocusNode.dispose();

    // Restaura a orientação vertical.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

// Representação visual:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                MouseSidebar(
                  onBack: () => Navigator.maybePop(context),
                  onKeyboard: _openKeyboard,
                  onShortcuts: () => _showDevelopment('Atalhos'),
                  onForward: () => _showDevelopment('Próxima função'),
                  onSettings: () => _showDevelopment('Configurações'),
                ),

                Expanded(
                  child: Column(
                    children: [
                      // Status da conexão.
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          top: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: _connected
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 7),
                            Text(_status),
                          ],
                        ),
                      ),

                      // Área touch e botões do mouse.
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: TouchpadArea(
                                onMovement: _connected
                                    ? _sendMovement
                                    : null,
                                onTap: _connected
                                    ? _sendLeftClick
                                    : null,
                                onDragStart: _connected
                                    ? _sendStartDrag
                                    : null,
                                onDragEnd: _connected
                                    ? _sendEndDrag
                                    : null,
                              ),
                            ),

                            // Botões esquerdo e direito.
                            Container(
                              color: const Color(0xFF202A32),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: MouseButtons(
                                onLeftClick: _connected
                                    ? _sendLeftClick
                                    : null,
                                onRightClick: _connected
                                    ? _rightClick
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Campo invisível para abrir o teclado nativo.
            Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                width: 1,
                height: 1,
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _keyboardController,
                    focusNode: _keyboardFocusNode,
                    autofocus: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
