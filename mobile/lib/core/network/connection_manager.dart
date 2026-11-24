// Gerencia e organiza a conexão, desconexão

// imports
import '../../features/mouse/models/pointer_event.dart';
import 'tcp_client.dart';

// Essa classe ira controlar as conexões tcp
class ConnectionManager {
  // Ela implementa um padrão chamado Singleton
  // O objetivo é garantir que o aplicativo utilize uma única instância de ConnectionManager.

  // final quer dizer que impede que essa variável receba outra referência depois de inicializada.
  static final ConnectionManager _instance = ConnectionManager._internal();

  factory ConnectionManager() {
    return _instance;
  }

  ConnectionManager._internal();
  // a mesma coisa que o anterior, o final garante que a variável nao pode apontar pra outro objeto, ou seja
  final TcpClient _client = TcpClient();

  // Verificando se o cliente tcp está conectado
  bool get isConnected => _client.isConnected;

  // Func de conexão
  // Em resumo:
  // -> Future indicará uma operação que pode terminar no futuro
  // -> Void indica que a função nao vai retornar um valor
    Future<void> connect(
      String ip,
      int port,
    ) async {
      await _client.connect(ip, port);
    }
    
  // ============================================================================================== //
  // Envia os comandos do mouse pra controlar o cursor do computador
  // essa função recebe um objeto com os movimentos
  void sendMovement(PointerMovement event) {
    if (!isConnected) return;
    _client.sendMovement(event);
  }

  // Função que solicita que o TcpClient envie o comando para pressionar/arrastar o botão esquerdo
  void sendStartDrag() {
    if (!isConnected) return;
    _client.sendStartDrag();
  }

  // Já essa é o contrário, faz com que solte a "seleção" do botão esquerdo
  void sendEndDrag() {
    if (!isConnected) return;
    _client.sendEndDrag();
  }

  // Aqui como o próprio nome da pra entender, as proximas funções se tratam da conexão com o clique equerdo e direito

  void sendLeftClick() {
    if (!isConnected) return;
    _client.sendLeftClick();
  }

  void sendRightClick() {
    if (!isConnected) return;
    _client.sendRightClick();
  }

  // Essa é uma func de conexão para futuramente implementar o teclado virtual

  void sendText(String text) {
    if (!isConnected) return;
    _client.sendText(text);
  }

  // Aqui desconecta
  void disconnect() {
    _client.disconnect();
  }
}
