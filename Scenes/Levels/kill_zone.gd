extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("ded")
		DoorTransition.reload_scene()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("ded")
		DoorTransition.reload_scene()
