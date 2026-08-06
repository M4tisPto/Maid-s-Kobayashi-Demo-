extends CharacterBody2D
var player: CharacterBody2D = null
@export var speed := 50
@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := -1
var chase_speed = 80
var is_chasing = false
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if is_chasing and is_instance_valid(player):
		if player.global_position.x > global_position.x:
			direction = 1
		else:
			direction = -1
		velocity.x = direction * chase_speed
	else:
		velocity.x = direction * speed

	move_and_slide()
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * speed
	move_and_slide()
	if is_on_floor():
		if is_on_wall():
			direction *= -1
	


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_chasing = true
	await get_tree().create_timer(3.5).timeout
	print("chasing player!")


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		is_chasing = false


func _on_hurtbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
