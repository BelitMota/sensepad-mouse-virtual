
import socket
import secrets
import json

from pathlib import Path
from typing import TypedDict, cast

import qrcode
from qrcode.image.pil import PilImage


PORT: int = 5000


class PairingData(TypedDict):
    app: str
    ip: str
    port: int
    token: str


def get_local_ip() -> str:
    """Descobre o IP utilizado pelo computador na rede local."""

    connection: socket.socket = socket.socket(
        socket.AF_INET,
        socket.SOCK_DGRAM
    )

    try:
        connection.connect(("8.8.8.8", 80))
        ip: str = connection.getsockname()[0]

    finally:
        connection.close()

    return ip


def create_pairing_data() -> PairingData:
    """Cria os dados necessários para o pareamento."""

    ip: str = get_local_ip()
    token: str = secrets.token_urlsafe(32)

    data: PairingData = {
        "app": "SensePad",
        "ip": ip,
        "port": PORT,
        "token": token
    }

    return data


def generate_qr(data: PairingData) -> None:
    """Gera e exibe o QR Code."""

    content: str = json.dumps(data)

    qr: PilImage = cast(PilImage, qrcode.make(content))

    output_path: Path = Path("sensepad_qr.png")

    qr.save(str(output_path))

    print(f"QR Code gerado: {output_path}")
    print(f"IP: {data['ip']}")
    print(f"Porta: {data['port']}")
    print("Aguardando conexão...")

    qr.show()
