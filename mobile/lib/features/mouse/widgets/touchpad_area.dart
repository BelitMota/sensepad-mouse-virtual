
import 'package:flutter/material.dart';

import '../models/pointer_event.dart';

class TouchpadArea extends StatefulWidget {
  final ValueChanged<PointerMovement>? onMovement;
  final VoidCallback? onTap;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;

  const TouchpadArea({
    super.key,
    this.onMovement,
    this.onTap,
    this.onDragStart,
    this.onDragEnd,
  });

  @override
  State<TouchpadArea> createState() => _TouchpadAreaState();
}

class _TouchpadAreaState extends State<TouchpadArea> {
  int? _activePointer;

  Offset _totalMovement = Offset.zero;

  bool _isDragging = false;
  bool _isWaitingForSecondTap = false;

  DateTime? _firstTapTime;

  static const double _tapThreshold = 8.0;
  static const int _doubleTapDuration = 300;

  void _handlePointerDown(PointerDownEvent event) {
    if (_activePointer != null) return;

    _activePointer = event.pointer;
    _totalMovement = Offset.zero;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer) return;

    _totalMovement += event.delta;

    // Se já estamos selecionando, continua arrastando.
    if (_isDragging) {
      widget.onMovement?.call(
        PointerMovement(
          dx: event.delta.dx,
          dy: event.delta.dy,
        ),
      );
      return;
    }

    // Movimento normal do cursor.
    widget.onMovement?.call(
      PointerMovement(
        dx: event.delta.dx,
        dy: event.delta.dy,
      ),
    );
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (event.pointer != _activePointer) return;

    if (_totalMovement.distance < _tapThreshold) {
      _handleTap();
    }

    _resetPointer();
  }

  void _handleTap() {
    final now = DateTime.now();

    // Se já estamos selecionando, outro toque encerra a seleção.
    if (_isDragging) {
      widget.onDragEnd?.call();
      _isDragging = false;
      _isWaitingForSecondTap = false;
      _firstTapTime = null;
      return;
    }

    // Verifica se este é o segundo toque.
    if (_isWaitingForSecondTap &&
        _firstTapTime != null &&
        now.difference(_firstTapTime!).inMilliseconds <=
            _doubleTapDuration) {
      _isWaitingForSecondTap = false;
      _firstTapTime = null;

      _isDragging = true;
      widget.onDragStart?.call();
      return;
    }

    // Primeiro toque.
    _isWaitingForSecondTap = true;
    _firstTapTime = now;

    widget.onTap?.call();
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (event.pointer != _activePointer) return;

    if (_isDragging) {
      widget.onDragEnd?.call();
      _isDragging = false;
    }

    _resetPointer();
  }

  void _resetPointer() {
    _activePointer = null;
    _totalMovement = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: Container(
        color: const Color(0xFF202A32),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text(
            _isDragging
                ? 'Modo de seleção ativado'
                : 'Área de movimentação',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
