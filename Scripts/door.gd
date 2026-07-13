extends Area2D

func _input(event):
	if event.is_action_pressed("up"):
		print(get_overlapping_bodies().size())
		if get_overlapping_bodies().size() >= 1:
			DoorTransition.load_scene("res://Scenes/Levels/level_test_scenes/test_level_second part.tscn")
