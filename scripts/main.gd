extends Control

const PLATFORM_PATH = "res://actors/Plataform.tscn"
const BREAKABLE_PLATFORM_PATH = "res://actors/BreakablePlatform.tscn"
const MOVING_PLATFORM_PATH = "res://actors/MovingPlatform.tscn"  # Novo caminho para a plataforma móvel
const BREAKABLE_PLATFORM_CHANCE = 0.2  # 20% de chance de gerar uma plataforma quebrável
const MOVING_PLATFORM_CHANCE = 0.1  # 10% de chance de gerar uma plataforma móvel

const SCREEN_WIDTH = 648
const SCREEN_HEIGHT = 1000
var scroll_speed = 10.0
var initial_position = Vector2(375.0, 200.0)  # Define a posição inicial desejada para YSort

var scroll_speed_increase = 3
var scroll_speed_increase_interval = 10.0  # Intervalo para aumento da velocidade (em segundos)
var time_elapsed = 0.0  # Variável para rastrear o tempo decorrido

@onready var timer := $Timer
@onready var ysort := $YSort
@onready var score_label := $CanvasLayer/ScoreLabel  # Referência ao Label de pontuação dentro do CanvasLayer

var last_y_position: float  # Variável para rastrear a última posição Y onde a plataforma foi gerada
var moving = false  # Variável para controlar se o jogador está se movendo

# Variáveis para a pontuação
var score = 0
var score_timer = 0.0  # Tempo do último incremento da pontuação
var score_interval = 2.0  # Intervalo para incremento da pontuação (em segundos)

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

	if score_label:
		score_label.text = str(score)  # Inicializa o texto do Label com a pontuação inicial
	else:
		print("ScoreLabel node not found")

func _process(delta):
	if ysort:
		if moving:
			ysort.position.y -= scroll_speed * delta
			time_elapsed += delta
			if time_elapsed >= scroll_speed_increase_interval:
				scroll_speed += scroll_speed_increase
				time_elapsed = 0.0  # Reinicia o tempo decorrido

			score_timer += delta
			if score_timer >= score_interval:
				score += 1
				score_timer = 0.0  # Reinicia o timer de pontuação
				print("Score: ", score)
				_update_score_label()  # Atualiza o Label com a nova pontuação
		else:
			score_timer = 0.0  # Reinicia o timer de pontuação se o personagem não estiver se movendo
	else:
		print("YSort node not found")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode in [KEY_W, KEY_A, KEY_S, KEY_D, KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]:
				moving = true

func _on_timer_timeout():
	_generate_platform()

func _generate_platform():
	var platform_scene_path = PLATFORM_PATH
	
	var rand_value = randf()
	if rand_value < MOVING_PLATFORM_CHANCE:
		platform_scene_path = MOVING_PLATFORM_PATH  # Gera uma plataforma móvel
	elif rand_value < MOVING_PLATFORM_CHANCE + BREAKABLE_PLATFORM_CHANCE:
		platform_scene_path = BREAKABLE_PLATFORM_PATH  # Gera uma plataforma quebrável

	if ResourceLoader.exists(platform_scene_path):
		var platform = load(platform_scene_path).instantiate()
		if platform:
			var x_position = randi_range(250, 500)
			var y_position = last_y_position - randi_range(50, 80)
			platform.position = Vector2(x_position, y_position)
			ysort.add_child(platform)

			last_y_position = y_position
		else:
			print("Failed to instantiate platform.")
	else:
		print("Platform scene not found")

func _update_score_label():
	if score_label:
		score_label.text = str(score)
