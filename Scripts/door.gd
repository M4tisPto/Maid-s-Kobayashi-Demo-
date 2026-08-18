extends Area2D

@export_file("*.tscn") var next_section_path: String

func _input(event):
	if event.is_action_pressed("up"):
		if has_overlapping_bodies():
			if next_section_path != "":
				var player = get_tree().get_first_node_in_group("player")
				GameManager.save_player(player)
				DoorTransition.load_scene(next_section_path)
			else:
				print("Error: No se asignó ninguna ruta de escena en el Inspector.")
