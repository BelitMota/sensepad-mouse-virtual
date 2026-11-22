# Movimenta o cursor
# Converte as coordenadas recebidas em movimentos do cursor.

# imports
import pyautogui

# Configurações do controle do mouse
pyautogui.PAUSE = 0

SENSITIVITY = 2.0

# Aqui é o movimento do cursor conforme o dedo se movimenta pela tela touch dentro do app
# Ele pega as coordenadas x,y e multiplica pela sensibilidade estabelecida
def move_cursor(dx: float, dy: float) -> None:
    pyautogui.moveRel(
        dx * SENSITIVITY,
        dy * SENSITIVITY,
        duration=0 # isso quer dizer que é "instantâneo"
    )

# Clique esquerdo
def left_click() -> None:
    pyautogui.click(button="left")

# Clique direito
def right_click() -> None:
    pyautogui.click(button="right")

# Seleciona e arrasta os itens

# Esse pressiona e mantém o botão esquerdo do mouse pressionado, sem soltá-lo imediatamente
def start_drag() -> None:
    pyautogui.mouseDown(button="left")

# Esse libera o botão esquerdo do mouse que estava pressionado
def end_drag() -> None:
    pyautogui.mouseUp(button="left")
