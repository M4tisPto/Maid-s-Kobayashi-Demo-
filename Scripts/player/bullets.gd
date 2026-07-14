extends Area2D
var direction : int 
var speed: int = 600



func _physics_process(delta: float) -> void:
	move_local_x(direction * speed * delta)


func _on_timer_timeout() -> void:
	queue_free()
