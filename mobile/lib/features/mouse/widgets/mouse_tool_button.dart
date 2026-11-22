
import 'package:flutter/material.dart';

class MouseToolButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const MouseToolButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: const Color(0xFF8CBFD4),
        borderRadius: BorderRadius.circular(14),
        elevation: 2,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 54,
            height: 54,
            child: Icon(
              icon,
              color: const Color(0xFF263746),
              size: 27,
            ),
          ),
        ),
      ),
    );
  }
}
