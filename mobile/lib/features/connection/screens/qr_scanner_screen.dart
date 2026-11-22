
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/device_model.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _processing = false;

  void _handleScan(BarcodeCapture capture) {
    if (_processing || capture.barcodes.isEmpty) {
      return;
    }

    final String? rawValue = capture.barcodes.first.rawValue;

    if (rawValue == null) return;

    _processing = true;

    try {
      final dynamic decoded = jsonDecode(rawValue);

      if (decoded is! Map) {
        throw const FormatException(
          'Conteúdo do QR Code inválido.',
        );
      }

      final Map<String, dynamic> data =
          Map<String, dynamic>.from(decoded);

      final DeviceModel device = DeviceModel.fromJson(data);

      // Devolve o computador encontrado para a tela anterior.
      Navigator.pop(context, device);

    } catch (error) {
      _processing = false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR Code inválido: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
      ),

      body: Column(
        children: [
          const SizedBox(height: 24),

          const Text(
            'Conectar ao computador',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Aponte a câmera para o QR Code exibido '
              'pelo SensePad Desktop.',
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MobileScanner(
                  onDetect: _handleScan,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Mantenha o código dentro da área da câmera.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
