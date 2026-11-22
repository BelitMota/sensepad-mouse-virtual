# OQ ESSE ARQUIVO FAZ?
# Servidor TCP: recebe conexões e mensagens.


# O que é um socket?
# é um endpoint, de comunicação, onde um recebe dados e envia dados

import socket
import json
from typing import Any;

from mouse.cursor_control import (
    move_cursor,
    left_click,
    right_click,
    mouse_down,
    mouse_up
)

# configurações do servidor
HOST = "0.0.0.0";
PORT = 5000;

def process_command(command: dict[str, Any]) -> None:
    """Interpreta e executa os comandos recebidos."""

    command_type = command.get("type")

    # Movimento do cursor
    if command_type == "move":
        dx = command.get("dx", 0)
        dy = command.get("dy", 0)

        if isinstance(dx, (int, float)) and isinstance(dy, (int, float)):
            move_cursor(dx, dy)
            print(f"Movimento: dx={dx}, dy={dy}")

        # Cliques
    elif command_type == "click":
        button = command.get("button")

        if button == "left":
            left_click()
            print("Clique esquerdo executado.")

        elif button == "right":
            right_click()
            print("Clique direito executado.")

        else:
            print("Botão desconhecido:", button)


    elif command_type == "mouse_down":
        mouse_down()
        print("Botão esquerdo pressionado.")

    elif command_type == "mouse_up":
        mouse_up()
        print("Botão esquerdo liberado.")

    # Texto do teclado (implementaremos depois)
    elif command_type == "text":
        print("Texto recebido:", command.get("text", ""))

    else:
        print("Comando desconhecido:", command)


def ligando_servidor():

    # Criando o socket TCP
    server = socket.socket(
        socket.AF_INET,
        socket.SOCK_STREAM
    )

    server.setsockopt(
        socket.SOL_SOCKET,
        socket.SO_REUSEADDR,
        1
    )

    server.bind((HOST, PORT))
    server.listen(5)

    print(f"Servidor aguardando conexões na porta {PORT}...")

    try:
        # Aceita conexões continuamente
        while True:

            connection, address = server.accept()

            print(f"Dispositivo conectado: {address}")

            with connection:

                buffer = b""

                while True:

                    data = connection.recv(1024)

                    if not data:
                        print("Dispositivo desconectado.")
                        break

                    buffer += data

                    # Separa mensagens pelo caractere \n
                    while b"\n" in buffer:

                        message, buffer = buffer.split(b"\n", 1)

                        if not message:
                            continue

                        try:
                            decoded_message = message.decode("utf-8")
                            command = json.loads(decoded_message)

                            process_command(command)

                        except (UnicodeDecodeError, json.JSONDecodeError):
                            print("Mensagem inválida recebida.")

    except KeyboardInterrupt:
        print("\nServidor encerrado.")

    finally:
        server.close()


if __name__ == "__main__":
    ligando_servidor()

# referencias:
# Sockets Tutorial with Python 3 part 1 - sending and receiving data --> https://www.youtube.com/watch?v=Lbfe3-v7yE0
