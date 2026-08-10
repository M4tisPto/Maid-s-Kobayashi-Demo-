extends Node

const PLAYER = preload("res://Scenes/player.tscn")


signal camera_shook( intensity : float, duration :float )

func shake_camera(intensity: float, duration: float) -> void:
	var safe_intensity = clamp(intensity, 0.0, 1.0)
	

	camera_shook.emit(safe_intensity, duration)
