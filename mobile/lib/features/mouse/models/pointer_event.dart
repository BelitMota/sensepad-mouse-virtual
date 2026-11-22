// Representação das coordenadas.

class PointerMovement {
  final double dx;
  final double dy;

  const PointerMovement({
    required this.dx,
    required this.dy,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': 'move',
      'dx': dx,
      'dy': dy,
    };
  }
}
