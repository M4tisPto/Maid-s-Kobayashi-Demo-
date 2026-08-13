extends CharacterBody2D

@export var speed := 100
@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := -1


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * speed
	move_and_slide()
	if is_on_floor():
		if is_on_wall():
			direction *= -1
