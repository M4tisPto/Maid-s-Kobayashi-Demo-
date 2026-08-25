#enemy script

class_name Enemy extends CharacterBody2D

@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed := 100

@onready var ground_check: RayCast2D = $GroundRay
@onready var collision_hitbox: CollisionShape2D = $Hitbox/collision_hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var collision_hurtbox: CollisionShape2D = $Hurtbox/collision_hurtbox

var direction = 1
var is_stunned = false
func _ready() -> void:
	update_raycast_direction()
func _physics_process(delta: float) -> void:
	if GameManager.is_collisions_checked:
		$colission.visible = true
		$Hitbox/collision_hitbox.visible = true
		$Hurtbox/collision_hurtbox.visible = true
		$GroundRay.visible = true
	else:
		$colission.visible = false
		$Hitbox/collision_hitbox.visible = false
		$Hurtbox/collision_hurtbox.visible = false
		$GroundRay.visible = false
	if not is_on_floor():
		velocity.y += gravity * delta
	if not is_stunned:
		sprite.play("walkin")
		velocity.x = direction * speed
	else:
		sprite.play("hurt")
		if is_on_floor():
			$Hitbox/collision_hitbox.set_deferred("disabled", true)
			velocity.x = move_toward(velocity.x, 0, speed * delta * 51)

	move_and_slide()
	
	if not is_stunned:
		if is_on_wall() or not ground_check.is_colliding():
			direction *= -1
			sprite.flip_h = direction == -1
			update_raycast_direction()
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
	if area.is_in_group("player_attack_combo_1"):
		HitstopManager.hit_stop_enemy_comboed()
		if not is_stunned:
			velocity.y = -370
		is_stunned = true
	if area.is_in_group("player_attack_combo_2"):
		HitstopManager.hit_stop_enemy_comboed()
		velocity.y = 200
		await get_tree().create_timer(2.5).timeout
		is_stunned = false

	if area.is_in_group("player_attack_combo_3"):
		HitstopManager.hit_stop_enemy_comboed()
		var player = area.owner
		velocity.x = player.facing_direction * 800 
		await get_tree().create_timer(3.5).timeout
		is_stunned = false

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
	if not is_stunned:
		velocity.y = -250
		velocity.x = player_dir * 900
	is_stunned = true
	collision_hitbox.set_deferred("disabled", true)
	await get_tree().create_timer(0.15).timeout
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.6).timeout
	collision_hitbox.set_deferred("disabled", false)
	is_stunned = false
func shockwave_hit(player_dir: int) -> void:
	is_stunned = true
	velocity.y = -650
	velocity.x = player_dir * 250
	animation_player.play("enemy_stunned_or_some_shi")
	collision_hitbox.set_deferred("disabled", true) 
	

	await get_tree().create_timer(0.2).timeout

	while not is_on_floor():
		await get_tree().physics_frame
	await get_tree().create_timer(3.5).timeout
	
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
func update_raycast_direction() -> void:
	ground_check.target_position = Vector2(direction * 20, 20)
