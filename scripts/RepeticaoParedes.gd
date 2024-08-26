extends TileMap

@onready var ysort := get_tree().get_root().get_node("YSort")  # Ajuste o caminho conforme necessário

# Variáveis para o TileMap
var tile_height: float = 64.0  # Defina o tamanho do tile manualmente, se conhecido
var offset_y: float = 0.0  # Variável para acompanhar o deslocamento
var initialized: bool = false

func _ready():
	# Verifica continuamente até que o ysort tenha uma posição válida
	await wait_until_ysort_ready()
	
	# Verifica se ysort foi inicializado corretamente
	if ysort:
		offset_y = ysort.position.y
		initialized = true
		print("YSort position set to ", offset_y)
	else:
		print("YSort node is null during _ready")

	# Defina o tamanho do tile manualmente, se não puder obter o tamanho do TileSet
	tile_height = 64.0  # Atualize com o tamanho real do seu tile se conhecido

func _process(delta):
	if initialized and ysort:
		var ysort_position = ysort.position.y
		# Atualiza o deslocamento do TileMap para criar o efeito de repetição
		if ysort_position - offset_y > tile_height:
			# Move o TileMap para criar o efeito de repetição
			offset_y += tile_height
			# Atualiza a posição do TileMap
			position.y = -offset_y
	else:
		print("YSort node is null during _process")

func wait_until_ysort_ready() -> void:
	while not ysort or ysort.position == Vector2.ZERO:
		await get_tree().create_timer(0.1).timeout
