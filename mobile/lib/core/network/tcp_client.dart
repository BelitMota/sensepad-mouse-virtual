// Conexão com o IP e porta do computador.

// Imports
import 'dart:convert';
import 'dart:io';

import '../../features/mouse/models/pointer_event.dart';

// Criando um cliente tcp dentro do app mobile (responsável por estabelecer e controlar a comunicação TCP com o computador)
class TcpClient {
  Socket? _socket; // aq vai guardar a conexão tcp se existir (o ? no Socket permite que a variável seja nula, ou seja, não exista uma conexão ativa)
  bool get isConnected => _socket != null; // aq só vai verificar se existe um socket armazenado

  Future<void> connect(
    String host,
    int port,
  ) async {
    disconnect();

// aq vai tentar fazer a conexão
    final Socket socket = await Socket.connect(
      host,
      port,
      timeout: const Duration(seconds: 5),
    );

// Armazena a conexão
    _socket = socket;

// Já esse fica "escutando"/ monitorando a comunicação entre os dispositivos
    socket.listen(
      (List<int> data) {},
      onDone: () {
        if (identical(_socket, socket)) {
          _socket = null;
        }
      },
      onError: (Object error) {
        if (identical(_socket, socket)) {
          _socket = null;
        }
      },
      cancelOnError: true,
    );

    // Envia o token para autenticar o dispositivo.
  //   _send({
  //     'type': 'auth',
  //     'token': token,
  //   });
  }

// ================================================================================================ //

//Função privada de envio
  void _send(Map<String, dynamic> data) { // basicamente aq ta dizendo que armazena informações em pares de chave e valor do tipo string e "dinamico"
    final Socket? socket = _socket;
    if (socket == null) return; // verificação simples

    final String message = jsonEncode(data); // converte o map em um JSON

    socket.write('$message\n'); // envia essa string
  }

// ================================================================================================ //
// Comandos do mouse

// Coordenadas do movimento
  void sendMovement(PointerMovement event) {
    _send(event.toJson());
  }

// start_drag: pressiona e mantém o botão esquerdo do mouse pressionado
  void sendStartDrag() {
    _send({'type': 'start_drag'});
  }

// end_drag: libera o botão esquerdo do mouse que estava pressionado
  void sendEndDrag() {
    _send({'type': 'end_drag'});
  }

// Clique esquerdo
  void sendLeftClick() {
    _send({
      'type': 'click',
      'button': 'left',
    });
  }

// Clique direito
  void sendRightClick() {
    _send({
      'type': 'click',
      'button': 'right',
    });
  }

// Texto a ser digitado
  void sendText(String text) {
    _send({
      'type': 'text',
      'text': text,
    });
  }

// Desconecta
  void disconnect() {
    _socket?.destroy();
    _socket = null;
  }
}