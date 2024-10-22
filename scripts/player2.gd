extends CharacterBody2D

const WALK_SPEED = 100.0
const RUN_SPEED = 200.0
const JUMP_FORCE = -600.0

const SCREEN_HEIGHT = 600  # Ajuste conforme necessário para corresponder à altura da tela

# Obtém a gravidade das configurações do projeto.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
@onready var animation := $animCapivara as AnimatedSprite2D  # Ajuste se necessário para o seu nó de animação
@onready var chain := $"../Chain" as Node2D  # Referência para a corrente
@onready var jump_sound = $jump

func _process(delta):
	# Verifica se o personagem caiu fora da tela
	if position.y > SCREEN_HEIGHT:
		die()
		#print('teste')

func _physics_process(delta):
	# Adiciona a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Manipula o pulo
	if Input.is_action_just_pressed("w") and is_on_floor() and not is_chain_stretched():
		velocity.y = JUMP_FORCE
		is_jumping = true
		jump_sound.play()
	elif is_on_floor():
		is_jumping = false

	# Obtém a direção de entrada e manipula o movimento/desaceleração
	var direction = Input.get_axis("a", "d")
	var is_running = Input.is_action_pressed("run2")  # Verifica se a tecla de correr está pressionada
	var speed = WALK_SPEED

	if is_running:
		speed = RUN_SPEED

	if direction != 0:
		velocity.x = direction * speed
		animation.scale.x = direction
		if not is_jumping:
			animation.play("run")
	elif is_jumping:
		animation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		animation.play("idle")

	# Limita a movimentação baseado na corrente
	if chain:
		var direction_to_player1 = (chain.player1.position - position).normalized()
		if position.distance_to(chain.player1.position) > (chain.chain_length * 20):
			# Limita a movimentação horizontal
			if direction_to_player1.x < 0:
				velocity.x = min(velocity.x, 0)  # Permite movimentação para a esquerda
			elif direction_to_player1.x > 0:
				velocity.x = max(velocity.x, 0)  # Permite movimentação para a direita

	move_and_slide()

func is_chain_stretched() -> bool:
	return chain and position.distance_to(chain.player1.position) > (chain.chain_length * 20)


func die():
	var scene_path = "res://scenes/reset.tscn"
	var tree = get_tree()
	if tree:
		if FileAccess.file_exists(scene_path):
			tree.change_scene_to_file(scene_path) 
		else:
			print("Caminho da cena não encontrado: ", scene_path)
	else:
		print("Árvore de cena não encontrada!")

func _on_area_2d_body_entered(body):
	if body.is_in_group("players"):
		die()
		#print("teste")
