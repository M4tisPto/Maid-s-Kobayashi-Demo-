extends CharacterBody2D

@export var speed := 100
@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := 1
var player: Player
@onready var ground_check  = $GroundRay

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction * speed
	
	move_and_slide()
	if is_on_wall() or !ground_check.is_colliding():
		direction *= -1
	
	update_raycast_direction()




func update_raycast_direction():
	ground_check.target_position = Vector2(direction * 20, 20)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body == player:
		queue_free()
