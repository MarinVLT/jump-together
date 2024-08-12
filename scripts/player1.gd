extends CharacterBody2D

const WALK_SPEED = 100.0
const RUN_SPEED = 200.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
@onready var animation := $anim as AnimatedSprite2D
@onready var chain := $"../Chain" as Node2D # Referencia para a corrente

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor() and !is_chain_stretched():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	var is_running = Input.is_action_pressed("run1")  # Check if the run key is pressed (Shift)
	var speed = WALK_SPEED

	if is_running:
		speed = RUN_SPEED

	if direction:
		velocity.x = direction * speed
		animation.scale.x = direction
		if !is_jumping:
			animation.play("run")
	elif is_jumping:
		animation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		animation.play("idle")

	# Limitar a movimentação baseado na corrente
	if chain:
		var direction_to_player2 = (chain.player2.position - position).normalized()
		if position.distance_to(chain.player2.position) > (chain.chain_length * 20):
			# Limitar movimentação horizontal
			if direction_to_player2.x < 0:
				velocity.x = min(velocity.x, 0) # Permite movimentação para a esquerda
			elif direction_to_player2.x > 0:
				velocity.x = max(velocity.x, 0) # Permite movimentação para a direita
			# Limitar pulo
			#velocity.y = min(velocity.y, 0) # Limita a velocidade vertical para não pular alto

	move_and_slide()

func is_chain_stretched() -> bool:
	return chain and position.distance_to(chain.player2.position) > (chain.chain_length * 20)
