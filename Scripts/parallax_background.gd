extends ParallaxBackground

@export var scroll_speed: Vector2 = Vector2(200, 0)

func _process(delta: float) -> void:
	scroll_offset -= scroll_speed * delta
