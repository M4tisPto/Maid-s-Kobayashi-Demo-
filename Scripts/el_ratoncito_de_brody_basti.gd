extends Node2D
@onready var ratatin_causa: Node3D = $SubViewportContainer/SubViewport/ratatin_causa

@export var velocity_rotation : float = 5.0

func _process(delta: float) -> void:
	ratatin_causa.rotate_y(velocity_rotation * delta)
