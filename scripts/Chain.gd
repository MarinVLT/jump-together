extends Node2D

@export var chain_length: int = 5
@export var link_scene: PackedScene = preload("res://actors/Link.tscn")
@export var player1_path: NodePath = NodePath("Player1")
@export var player2_path: NodePath = NodePath("Player2")

var player1: CharacterBody2D
var player2: CharacterBody2D
var links: Array = []

func _ready():
	print("Nó raiz: ", get_tree().root)
	print("Nó atual: ", self)
	
	if player1_path.is_empty():
		print("player1_path não está definido.")
	if player2_path.is_empty():
		print("player2_path não está definido.")
	
	player1 = get_node(player1_path) as CharacterBody2D
	player2 = get_node(player2_path) as CharacterBody2D
	
	if player1 == null:
		print("player1 não foi encontrado no caminho: ", player1_path)
	if player2 == null:
		print("player2 não foi encontrado no caminho: ", player2_path)
	
	create_chain()

func create_chain():
	var previous_link = player1

	for i in range(chain_length):
		var link = link_scene.instantiate() as Node2D
		add_child(link)
		link.position = lerp(player1.position, player2.position, float(i) / chain_length)

		var joint = PinJoint2D.new()
		joint.node_a = previous_link.get_path()
		joint.node_b = link.get_path()
		joint.position = link.position
		add_child(joint)

		links.append(link)
		previous_link = link

	var joint_last = PinJoint2D.new()
	joint_last.node_a = previous_link.get_path()
	joint_last.node_b = player2.get_path()
	joint_last.position = player2.position
	add_child(joint_last)

func _process(_delta: float):
	var distance = player1.position.distance_to(player2.position)
	
	if distance > (chain_length * 20): # Ajuste o multiplicador conforme necessário
		var direction = (player2.position - player1.position).normalized()
		player1.velocity.x = direction.x * -50
		player2.velocity.x = direction.x * 50
