extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/dificulty_screen.tscn")


func _on_controls_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/controls_screen.tscn")


func _on_credits_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/credits_screen.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/medio.tscn")


func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://scenes/impossivel.tscn")
