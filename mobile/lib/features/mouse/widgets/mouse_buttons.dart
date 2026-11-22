
import 'package:flutter/material.dart';

class MouseButtons extends StatelessWidget {
  final VoidCallback? onLeftClick;
  final VoidCallback? onRightClick;

  const MouseButtons({
    super.key,
    this.onLeftClick,
    this.onRightClick,
  });

  Widget _buildButton(String label, VoidCallback? onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8CBFD4),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton('Esquerdo', onLeftClick),
        _buildButton('Direito', onRightClick),
      ],
    );
  }
}
