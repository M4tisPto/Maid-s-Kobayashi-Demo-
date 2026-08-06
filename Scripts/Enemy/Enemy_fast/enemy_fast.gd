extends CharacterBody2D

@export var speed := 100
@export var chase_speed := 130
@export var knockback_force := 300.0
@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var collision_hitbox: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var direction := 1
var player: CharacterBody2D = null
var is_chasing := false

var is_stunned = false
var knockback_velocity := Vector2.ZERO


func _ready():
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_chasing and is_instance_valid(player):
		if player.global_position.x > global_position.x:
			direction = 1
		else:
			direction = -1
		velocity.x = direction * chase_speed
	else:
		velocity.x = direction * speed

	move_and_slide()
	
	if is_on_floor() and is_on_wall() and not is_chasing:
		direction *= -1


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("knuckle_attack_player"):
		if is_stunned:
			return
		var player = area.owner
		var kb_arm = player.get_node_or_null("arm_state_machine/knuckleblaster_arm")
		if kb_arm and kb_arm.current_sub_state:
			match kb_arm.current_sub_state.name:
				"neutral":
					print("neutral?")
					neutral_hit(player.facing_direction)
				"side":
					print("side?")
					side_hit(player.facing_direction)
	if area.is_in_group("shockwave_player"):
		var player = area.owner
		var kb_arm = player.get_node_or_null("arm_state_machine/knuckleblaster_arm")
		if kb_arm and kb_arm.current_sub_state:
			match kb_arm.current_sub_state.name:
				"up":
					print("up??")
					up_hit()
				"down":
					print("down???")
					down_hit(player.facing_direction)
		else:
			shockwave_hit(player.facing_direction)



func neutral_hit(player_dir: int) -> void:
	is_stunned = true
	velocity.x = player_dir * 550
	velocity.y = -150
	collision_hitbox.set_deferred("disabled", true)
	await get_tree().create_timer(0.05).timeout
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.8).timeout
	collision_hitbox.set_deferred("disabled", false)
	is_stunned = false
func side_hit(player_dir: int) -> void:
	is_stunned = true
	velocity.y = -250
	velocity.x = player_dir * 900
	collision_hitbox.set_deferred("disabled", true)
	await get_tree().create_timer(0.15).timeout
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.6).timeout
	collision_hitbox.set_deferred("disabled", false)
	is_stunned = false



func shockwave_hit(player_dir: int) -> void:
	is_stunned = true
	velocity.y = -650
	velocity.x = player_dir * 250 # i'll figure out how to make the player direction works in the opisite way too
	animation_player.play("enemy_stunned_or_some_shi")
	collision_hitbox.set_deferred("disabled", true) 
	

	await get_tree().create_timer(0.2).timeout

	while not is_on_floor():
		await get_tree().physics_frame
	
	collision_hitbox.set_deferred("disabled", false)
	animation_player.play("RESET")
	is_stunned = false
func down_hit(player_dir: int) -> void:
	is_stunned = true
	velocity.y = -450
	velocity.x = player_dir * 250
	animation_player.play("another_hit_for_me_exclametion_mark")
	collision_hitbox.set_deferred("disabled", true) 
	await get_tree().create_timer(0.2).timeout
	while not is_on_floor():
		await get_tree().physics_frame
	await get_tree().create_timer(3.5).timeout
	
	collision_hitbox.set_deferred("disabled", false)
	animation_player.play("RESET")
	is_stunned = false
func up_hit():
	is_stunned = true
	velocity.y = -750
	velocity.x = 0
	animation_player.play("enemy_stunned_or_some_shi")
	collision_hitbox.set_deferred("disabled", true)
	await get_tree().create_timer(0.2).timeout
	while not is_on_floor():
		await get_tree().physics_frame
	await get_tree().create_timer(1.2).timeout
	collision_hitbox.set_deferred("disabled", false)
	animation_player.play("RESET")
	is_stunned = false

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_chasing = true
	await get_tree().create_timer(3.5).timeout
	print("chasing player!")


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		is_chasing = false
		player = null
		print("player lost")
