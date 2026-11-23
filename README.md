# SensePad — Mouse Virtual

Aplicação desenvolvida em **Flutter** e **Python** que transforma a tela sensível ao toque de um smartphone em um touchpad para controlar o cursor de um computador remotamente.

O projeto utiliza comunicação TCP para conectar o aplicativo mobile ao computador, permitindo enviar comandos de movimento, cliques e outras interações do mouse.

Desenvolvido como parte de um **Projeto Integrador da Universidade de Sorocaba (Uniso)**, para o curso de Análise e Desenvolvimento de Sistemas, com foco em acessibilidade digital e interação entre dispositivos.

> **Repositório:** [SensePad — Mouse Virtual](https://github.com/BelitMota/sensepad-mouse-virtual)

---

## Tecnologias Utilizadas

### Aplicativo Mobile
- **Flutter:** framework utilizado para desenvolvimento da interface mobile.
- **Dart:** linguagem de programação do aplicativo.
- **TCP Socket:** comunicação entre o smartphone e o computador.
- **JSON:** formato utilizado para estruturar e transmitir os comandos.

### Aplicação Desktop
- **Python:** linguagem utilizada no desenvolvimento do servidor desktop.
- **Socket:** implementação da comunicação TCP.
- **PyAutoGUI:** biblioteca responsável por executar ações do mouse no computador.

---

## Funcionalidades

- **Conexão TCP:** comunicação entre o aplicativo mobile e o computador.
- **Movimentação do cursor:** controle do ponteiro do mouse através da tela do smartphone.
- **Clique esquerdo e direito:** execução dos principais comandos do mouse.
- **Arrastar e selecionar:** permite pressionar e manter o botão esquerdo enquanto movimenta o cursor.
- **Comunicação em JSON:** envio dos comandos do aplicativo para o servidor desktop.
- **Teclado virtual:** estrutura preparada para futura implementação do envio de textos.

---

## Estrutura do Projeto

```text
SensePad/
├── mobile/
│   ├── lib/
│   │   ├── app/
│   │   ├── core/
│   │   │   └── network/
│   │   │       ├── connection_manager.dart
│   │   │       └── tcp_client.dart
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── connection/
│   │   │   ├── home/
│   │   │   ├── keyboard/
│   │   │   └── mouse/
│   │   │       ├── models/
│   │   │       │   └── pointer_event.dart
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   └── main.dart
│   └── pubspec.yaml
│
└── desktop/
    ├── mouse/
    │   └── cursor_control.py
    ├── network/
    │   └── server.py
    ├── main.py
    └── requirements.txt
```

### Organização dos principais arquivos

| Arquivo | Responsabilidade |
|---|---|
| `main.dart` | Inicialização do aplicativo Flutter. |
| `connection_manager.dart` | Gerenciamento das operações de conexão. |
| `tcp_client.dart` | Estabelecimento da conexão TCP e envio de mensagens. |
| `pointer_event.dart` | Modelo de dados dos movimentos do cursor. |
| `server.py` | Servidor TCP responsável por receber os comandos. |
| `cursor_control.py` | Execução das ações do mouse no computador. |
| `main.py` | Ponto de entrada da aplicação desktop. |

---

## Comunicação entre os Dispositivos

O SensePad utiliza uma arquitetura cliente-servidor:

1. O aplicativo Flutter estabelece uma conexão TCP com o computador.
2. O `TcpClient` organiza os comandos em mensagens JSON.
3. As mensagens são enviadas ao servidor Python através do socket.
4. O servidor interpreta os comandos recebidos.
5. O PyAutoGUI executa as ações correspondentes no computador.

### Fluxo de comunicação

```text
Smartphone (Flutter)
        |
        v
ConnectionManager
        |
        v
    TcpClient
        |
        | Comunicação TCP
        | Mensagens JSON
        v
Servidor Desktop (Python)
        |
        v
cursor_control.py
        |
        v
Controle do mouse
```

---

## Como Executar Localmente

### 1. Pré-requisitos

- Flutter SDK instalado.
- Dart SDK (incluído na instalação do Flutter).
- Python instalado.
- Dependências do projeto instaladas.
- Smartphone Android ou emulador.
- Computador e smartphone conectados à mesma rede Wi-Fi.

### 2. Executar o servidor desktop

Entre na pasta `desktop`:

```bash
cd desktop
```

Crie e ative um ambiente virtual Python:

```bash
python -m venv .venv
```

No Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

Instale as dependências:

```bash
pip install -r requirements.txt
```

Inicie o servidor:

```bash
python network/server.py
```

### 3. Executar o aplicativo mobile

Em outro terminal, entre na pasta `mobile`:

```bash
cd mobile
```

Instale as dependências Flutter:

```bash
flutter pub get
```

Execute o aplicativo:

```bash
flutter run
```

### 4. Estabelecer a conexão

Para estabelecer a comunicação:

- Verifique se o computador e o smartphone estão na mesma rede Wi-Fi.
- Identifique o endereço IPv4 do computador.
- Utilize o endereço IP e a porta configurada no servidor.
- Certifique-se de que o firewall do Windows permite a comunicação pela porta TCP utilizada.

**Porta padrão do projeto:** `5000`.

---

## Objetivo do Projeto

O SensePad busca oferecer uma alternativa de controle do computador por meio de dispositivos móveis, explorando a comunicação em rede e a interação por toque.

Além de desenvolver uma solução funcional, o projeto permite aplicar conhecimentos de desenvolvimento mobile, programação desktop, redes de computadores, arquitetura de software e integração entre diferentes tecnologias.

---

*Projeto acadêmico — Universidade de Sorocaba (Uniso).*  
*Análise e Desenvolvimento de Sistemas.*
