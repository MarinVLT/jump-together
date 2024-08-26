extends StaticBody2D

# Variáveis para a plataforma quebrável
@export var breakable = true
@export var break_animation_duration = 2
@onready var sprite := $AnimatedSprite2D # Ou AnimatedSprite, conforme o caso
@onready var area2d := $Area2D

func _ready():
	area2d.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body):
	if breakable and body.is_in_group("players"):
		print("player entrou")  # Verifica se o corpo que colidiu é o jogador
		break_platform()

func break_platform() -> void:
	print("quebrando plataforma")
	# Executa animação ou efeito de quebra
	if sprite:
		sprite.play("break")  # Supondo que você tenha uma animação chamada "break"
	
	# Remove a plataforma após o efeito de quebra
	await get_tree().create_timer(break_animation_duration).timeout
	queue_free()  # Remove a plataforma da cena
