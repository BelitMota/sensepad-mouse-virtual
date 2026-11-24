
# imports
import socket
import secrets
import json

from pathlib import Path
from typing import TypedDict, cast

import qrcode
from qrcode.image.pil import PilImage


# ============================================================ #
# Configurações

# Porta
PORT: int = 5000

class PairingData(TypedDict):
    app: str
    ip: str
    port: int
    token: str

# ============================================================ #
# ip local

def get_local_ip() -> str:
    """Descobre o IP utilizado pelo computador na rede local."""

    # cria um socket para identificar a interface de rede utilizada
    connection: socket.socket = socket.socket(
        socket.AF_INET,
        socket.SOCK_DGRAM
    )

    try:
        # simula uma conexão externa para descobrir o IP local
        connection.connect(("8.8.8.8", 80))
        ip: str = connection.getsockname()[0]

    finally:
        connection.close()

    return ip

# ============================================================ #
# Dados para pareamento

def create_pairing_data() -> PairingData:
    """Cria os dados necessários para o pareamento."""

    # Obtém o endereço IP do computador.
    ip: str = get_local_ip()

    # Gera um token aleatório para identificar o pareamento.
    token: str = secrets.token_urlsafe(32)

    # Organiza as informações necessárias para a conexão.
    data: PairingData = {
        "app": "SensePad",
        "ip": ip,
        "port": PORT,
        "token": token
    }

    return data


# ============================================================ #
# QR Code

def generate_qr(data: PairingData) -> None:
    """Gera e exibe o QR Code."""

    # converte os dados JSON
    content: str = json.dumps(data)

    # cria a imagem do QR Code
    qr: PilImage = cast(PilImage, qrcode.make(content))

    output_path: Path = Path("sensepad_qr.png")

    # salva a imagem
    qr.save(str(output_path))

    print(f"QR Code gerado: {output_path}")
    print(f"IP: {data['ip']}")
    print(f"Porta: {data['port']}")
    print("Aguardando conexão...")

    qr.show()