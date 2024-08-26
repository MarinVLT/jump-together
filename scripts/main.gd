extends Control

const PLATFORM_PATH = "res://actors/Plataform.tscn"
const SCREEN_WIDTH = 648
const SCREEN_HEIGHT = 1000
var scroll_speed = 10.0
var initial_position = Vector2(375.0, 200.0)  # Define a posição inicial desejada para YSort

var scroll_speed_increase = 3
var scroll_speed_increase_interval = 10.0  # Intervalo para aumento da velocidade (em segundos)
var time_elapsed = 0.0  # Variável para rastrear o tempo decorrido

@onready var timer := $Timer
@onready var ysort := $YSort

var last_y_position: float  # Variável para rastrear a última posição Y onde a plataforma foi gerada
var moving = false  # Variável para controlar se o jogador está se movendo

func _ready():
	if timer:
		timer.timeout.connect(_on_timer_timeout)
		timer.wait_time = 0.1  # Intervalo do timer reduzido para gerar plataformas mais frequentemente
		timer.start()
		print("Timer started successfully.")
	else:
		print("Timer node not found")
	
	if ysort:
		ysort.position = initial_position  # Define a posição inicial
		last_y_position = initial_position.y  # Define a última posição Y da plataforma para a posição inicial de YSort
		print("YSort node found. Initial position set to ", ysort.position)
	else:
		print("YSort node not found")

func _process(delta):
	if ysort:
		# Verifica se o jogador está se movendo
		if moving:
			# Mova o YSort para cima, diminuindo a posição y
			ysort.position.y -= scroll_speed * delta
			#print("YSort position: ", ysort.position)
		
		# Atualiza o tempo decorrido e ajusta a velocidade de rolagem
		time_elapsed += delta
		if time_elapsed >= scroll_speed_increase_interval:
			scroll_speed += scroll_speed_increase
			time_elapsed = 0.0  # Reinicia o tempo decorrido
	else:
		print("YSort node not found")

func _input(event):
	if event is InputEventKey:
		# Verifica se uma das teclas direcionais ou WASD está pressionada
		if event.pressed:
			if event.keycode in [KEY_W, KEY_A, KEY_S, KEY_D, KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]:
				moving = true

func _on_timer_timeout():
	print("Timer timeout occurred.")
	_generate_platform()

func _generate_platform():
	if PLATFORM_PATH and ResourceLoader.exists(PLATFORM_PATH):
		var platform = load(PLATFORM_PATH).instantiate()
		if platform:
			# Gera uma posição x dentro do intervalo desejado
			var x_position = randi_range(250, 500)
			# Reduz o intervalo de valores para a posição y para gerar plataformas mais próximas
			var y_position = last_y_position - randi_range(40, 60) 

			platform.position = Vector2(x_position, y_position)
			ysort.add_child(platform)  # Adiciona a plataforma ao nó YSort

			last_y_position = y_position  # Atualiza a última posição Y onde a plataforma foi gerada
		else:
			print("Failed to instantiate platform.")
	else:
		print("Platform scene not found")
