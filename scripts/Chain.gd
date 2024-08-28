extends Node2D

@export var chain_length: int = 23  # Aumente a quantidade de nós para melhorar a visibilidade
@export var link_scene: PackedScene = preload("res://actors/Link.tscn")
@export var player1_path: NodePath = NodePath("Player1")
@export var player2_path: NodePath = NodePath("Player2")
@export var max_spacing: float = 3  # Limite de espaçamento entre os links

var player1: CharacterBody2D
var player2: CharacterBody2D
var links: Array = []

func _ready():
	# Inicializa os jogadores
	player1 = get_node_or_null(player1_path) as CharacterBody2D
	player2 = get_node_or_null(player2_path) as CharacterBody2D
	
	# Verifica se os jogadores foram encontrados e cria a corrente
	if player1 and player2:
		create_chain()
	else:
		print("Não é possível criar a corrente. Um ou ambos os jogadores não foram encontrados.")

func create_chain():
	# Remove qualquer corrente existente antes de criar uma nova
	remove_links()
	
	if player1 == null or player2 == null:
		print("Não é possível criar a corrente, pois player1 ou player2 são nulos.")
		return
	
	var previous_link = player1

	for i in range(chain_length):
		var link = link_scene.instantiate() as RigidBody2D
		if link:
			add_child(link)
			link.position = lerp(player1.position, player2.position, float(i) / chain_length)

			var joint = PinJoint2D.new()
			joint.node_a = previous_link.get_path()
			joint.node_b = link.get_path()
			add_child(joint)

			links.append(link)
			previous_link = link
		else:
			print("Não foi possível instanciar o link.")

	# Cria o último joint para conectar o último link ao player2
	var joint_last = PinJoint2D.new()
	joint_last.node_a = previous_link.get_path()
	joint_last.node_b = player2.get_path()
	add_child(joint_last)

func remove_links():
	for link in links:
		if link and link.is_inside_tree():
			link.queue_free()
	links.clear()

func _process(_delta: float):
	# Verificação adicional para garantir que os jogadores ainda são válidos
	if player1 and player2:
		if player1.is_inside_tree() and player2.is_inside_tree():
			# Remove links inválidos antes de qualquer outra operação
			remove_invalid_links()

			var distance = player1.position.distance_to(player2.position)
			
			# Impede que os jogadores se afastem mais do que o comprimento da corrente
			if distance > chain_length * max_spacing:
				var direction = (player2.position - player1.position).normalized()
				
				# Calcula o ponto médio entre os jogadores para manter a corrente tensionada de forma equilibrada
				var mid_point = player1.position + direction * (distance / 2)
				
				# Reposiciona os jogadores ao redor do ponto médio
				player1.position = mid_point - direction * (chain_length * max_spacing / 2)
				player2.position = mid_point + direction * (chain_length * max_spacing / 2)
			
			# Comportamento de pendurar
			handle_hanging_behavior()

		else:
			print("Um ou ambos os jogadores não estão na árvore de nós ou foram removidos.")
	else:
		print("Um ou ambos os jogadores são nulos.")

func handle_hanging_behavior():
	var player1_on_ground = player1.is_on_floor() or player1.is_on_wall()
	var player2_on_ground = player2.is_on_floor() or player2.is_on_wall()
	
	if player1_on_ground and not player2_on_ground:
		# Player 1 está em uma plataforma e Player 2 está pendurado
		player2.velocity.y += 20  # Aumenta a velocidade de queda do Player 2 para simular pendurar
		player2.velocity.y = clamp(player2.velocity.y, -500, 500)  # Limita a velocidade do Player 2
	elif player2_on_ground and not player1_on_ground:
		# Player 2 está em uma plataforma e Player 1 está pendurado
		player1.velocity.y += 20  # Aumenta a velocidade de queda do Player 1 para simular pendurar
		player1.velocity.y = clamp(player1.velocity.y, -500, 500)  # Limita a velocidade do Player 1
	else:
		# Ambos os jogadores estão no ar ou no chão
		player1.velocity.y = clamp(player1.velocity.y, -650, 650)  # Mantém a velocidade de queda normal
		player2.velocity.y = clamp(player2.velocity.y, -650, 650)  # Mantém a velocidade de queda normal


func remove_invalid_links():
	for link in links:
		if not link.is_inside_tree():
			print("Link inválido encontrado. Removendo link.")
			links.erase(link)
			link.queue_free()
