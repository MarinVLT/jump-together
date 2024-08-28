extends Camera2D

@onready var ysort := get_tree().get_root().get_node("main/YSort")  

func _ready():
	if ysort:
		position = ysort.position
	else:
		print("YSort node not found")

func _process(delta):
	if ysort:
		position = ysort.position
