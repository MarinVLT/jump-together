extends StaticBody2D

# Variáveis de configuração
@export var speed: float = 30.0  # Velocidade de movimento
@export var move_range: Vector2 = Vector2(70, 0)  # Distância a ser percorrida pela plataforma (x e y)

var start_position: Vector2  # Posição inicial da plataforma
var direction: int = 1  # Direção do movimento (1 para frente, -1 para trás)

func _ready():
	# Armazena a posição inicial da plataforma
	start_position = position

func _process(delta):
	# Calcula a nova posição com base na direção e velocidade
	position.x += direction * speed * delta
	
	# Inverte a direção se a plataforma atingir o limite do movimento
	if abs(position.x - start_position.x) > move_range.x:
		direction *= -1
