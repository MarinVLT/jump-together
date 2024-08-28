extends Control

@onready var score_label := $VBoxContainer/HBoxContainer/ScoreLabel

var score = GlobalScore.score


# Called when the node enters the scene tree for the first time.
func _ready():
	if score_label:
		GlobalScore.score = 0
		score_label.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")


func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://scenes/dificulty_screen.tscn")
