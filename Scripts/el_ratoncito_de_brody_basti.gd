extends Node2D
@onready var ratatin_causa: Node3D = $SubViewportContainer/SubViewport/ratatin_causa
var is_grabbed = false
@export var velocity_rotation : float = 5.0
var velocity_grabbed = 500
func _process(delta: float) -> void:
	ratatin_causa.rotate_y(velocity_rotation * delta)
	if is_grabbed:
		ratatin_causa.position.y += velocity_grabbed * delta


func _on_legrab_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_grabbed = true


func _on_legrab_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_grabbed = true
