extends Area2D
@onready var test_section = preload("res://Scenes/Levels/level_test_scenes/test_level_second part.tscn") as PackedScene

func _input(event):
	if event.is_action_pressed("up"):
		print(get_overlapping_bodies().size())
		if get_overlapping_bodies().size() >= 1:
			get_tree().change_scene_to_packed(test_section)
