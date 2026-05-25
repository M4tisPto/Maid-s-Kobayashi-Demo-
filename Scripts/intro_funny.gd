extends Node2D
func _ready() -> void:
	await get_tree().create_timer(15.5).timeout
	get_tree().change_scene_to_file("res://Scenes/warning_screen.tscn")
