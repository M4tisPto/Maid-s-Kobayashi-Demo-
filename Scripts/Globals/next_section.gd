extends Area2D

@export_file("*.tscn") var next_section_path: String



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		DoorTransition.load_scene(next_section_path)
