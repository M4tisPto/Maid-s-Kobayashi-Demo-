class_name HurtBox
extends Area2D





func _on_body_entered(body: Node2D) -> void:
	print(body.name)
