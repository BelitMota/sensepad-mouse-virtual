
class DeviceModel {
  final String app;
  final String name;
  final String ip;
  final int port;
  final String token;

  const DeviceModel({
    required this.app,
    required this.name,
    required this.ip,
    required this.port,
    required this.token,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    final String? app = json['app'] as String?;
    final String? ip = json['ip'] as String?;
    final int? port = json['port'] as int?;
    final String? token = json['token'] as String?;
    final String? name = json['name'] as String?;

    if (app != 'SensePad') {
      throw const FormatException(
        'Este QR Code não pertence ao SensePad.',
      );
    }

    if (ip == null ||
        ip.isEmpty ||
        port == null ||
        port < 1 ||
        port > 65535 ||
        token == null ||
        token.isEmpty) {
      throw const FormatException(
        'Dados de conexão inválidos.',
      );
    }

    return DeviceModel(
      app: app!,
      name: name ?? 'Computador',
      ip: ip,
      port: port,
      token: token,
    );
  }
}
