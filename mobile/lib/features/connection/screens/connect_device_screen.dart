
import 'package:flutter/material.dart';

import '../../../core/network/connection_manager.dart';
import '../../mouse/screens/mouse_screen.dart';

import '../models/device_model.dart';
import '../widgets/connection_method_card.dart';
import 'qr_scanner_screen.dart';

class ConnectDeviceScreen extends StatefulWidget {
  const ConnectDeviceScreen({super.key});

  @override
  State<ConnectDeviceScreen> createState() =>
      _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState
    extends State<ConnectDeviceScreen> {

  final ConnectionManager _connection = ConnectionManager();

  bool _connecting = false;

  Future<void> _openQrScanner() async {
    final DeviceModel? device =
        await Navigator.push<DeviceModel>(
      context,
      MaterialPageRoute<DeviceModel>(
        builder: (_) => const QrScannerScreen(),
      ),
    );

    if (!mounted || device == null) return;

    await _connectDevice(device);
  }

  Future<void> _connectDevice(DeviceModel device) async {
    if (_connecting) return;

    setState(() {
      _connecting = true;
    });

    try {
      await _connection.connect(
        device.ip,
        device.port,
        device.token,
      );

      if (!mounted) return;

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

        content: Text(
          '$feature ainda está sendo desenvolvido.',
        ),

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar dispositivo'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Como deseja conectar?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Escolha uma forma de conectar seu '
                'celular ao computador.',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              ConnectionMethodCard(
                icon: Icons.qr_code_scanner,
                title: 'Ler QR Code',
                description:
                    'Escaneie o código exibido no computador.',
                available: !_connecting,
                onTap: _openQrScanner,
              ),

              const SizedBox(height: 12),

              ConnectionMethodCard(
                icon: Icons.wifi,
                title: 'Encontrar por Wi-Fi',
                description:
                    'Procure computadores disponíveis na rede.',
                available: false,
                onTap: () => _showDevelopment(
                  'Descoberta automática por Wi-Fi',
                ),
              ),

              const SizedBox(height: 12),

              ConnectionMethodCard(
                icon: Icons.usb,
                title: 'Conexão USB',
                description:
                    'Conecte seu celular diretamente ao computador.',
                available: false,
                onTap: () => _showDevelopment(
                  'Conexão USB',
                ),
              ),

              const SizedBox(height: 24),

              if (_connecting)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Conectando ao computador...'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
