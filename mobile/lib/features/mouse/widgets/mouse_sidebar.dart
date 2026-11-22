
import 'package:flutter/material.dart';
import 'mouse_tool_button.dart';

class MouseSidebar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onKeyboard;
  final VoidCallback onShortcuts;
  final VoidCallback onForward;
  final VoidCallback onSettings;

  const MouseSidebar({
    super.key,
    required this.onBack,
    required this.onKeyboard,
    required this.onShortcuts,
    required this.onForward,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MouseToolButton(
            icon: Icons.arrow_back,
            tooltip: 'Voltar',
            onPressed: onBack,
          ),

          Column(
            children: [
              MouseToolButton(
                icon: Icons.keyboard,
                tooltip: 'Teclado virtual',
                onPressed: onKeyboard,
              ),
              const SizedBox(height: 14),

              MouseToolButton(
                icon: Icons.grid_view,
                tooltip: 'Atalhos',
                onPressed: onShortcuts,
              ),
              const SizedBox(height: 14),

              MouseToolButton(
                icon: Icons.double_arrow,
                tooltip: 'Próxima função',
                onPressed: onForward,
              ),
            ],
          ),

          MouseToolButton(
            icon: Icons.settings,
            tooltip: 'Configurações',
            onPressed: onSettings,
          ),
        ],
      ),
    );
  }
}
