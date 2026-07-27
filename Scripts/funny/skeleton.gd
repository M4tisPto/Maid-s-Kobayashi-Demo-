extends AnimatedSprite2D

var speed = 400


func _process(delta: float) -> void:
	position.x += speed * delta
