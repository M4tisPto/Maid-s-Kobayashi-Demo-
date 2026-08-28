class_name Enemy extends CharacterBody2D

@export var speed := 100.0
@export var float_amplitude := 15.0
@export var float_speed := 2.0
@export var float_smoothness := 5.0

@onready var collision_hitbox: CollisionShape2D = $hitbox/CollisionShape2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D

var direction := 1
var is_stunned := false

var start_y := 0.0
var float_time := 0.0

func _ready() -> void:
	start_y = global_position.y
	float_time = randf() * TAU


func _physics_process(delta: float) -> void:
	if GameManager.is_collisions_checked:
		$CollisionShape2D.visible = true
		$hitbox/CollisionShape2D.visible = true
		$hurtbox/CollisionShape2D.visible = true
	else:
		$CollisionShape2D.visible = false
		$hitbox/CollisionShape2D.visible = false
		$hurtbox/CollisionShape2D.visible = false

	if not is_stunned:
		sprite.play("floating")

		velocity.x = direction * speed

		float_time += float_speed * delta

		var target_y := start_y + sin(float_time) * float_amplitude

		velocity.y = (target_y - global_position.y) * float_smoothness

	else:
		sprite.play("hurt")

	move_and_slide()

	if not is_stunned:
		if is_on_wall():
			direction *= -1
			sprite.flip_h = direction == -1


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("knuckle_attack_player"):
		if is_stunned:
			return

		var player = area.owner
		var kb_arm = player.get_node_or_null("arm_state_machine/knuckleblaster_arm")

		if kb_arm and kb_arm.current_sub_state:
			match kb_arm.current_sub_state.name:
				"neutral":
					neutral_hit(player.facing_direction)

				"side":
					side_hit(player.facing_direction)

	if area.is_in_group("shockwave_player"):
		var player = area.owner
		var kb_arm = player.get_node_or_null("arm_state_machine/knuckleblaster_arm")

		if kb_arm and kb_arm.current_sub_state:
			match kb_arm.current_sub_state.name:
				"up":
					up_hit()

				"down":
					down_hit(player.facing_direction)
		else:
			shockwave_hit(player.facing_direction)

	if area.is_in_group("player_attack_combo_1"):
		HitstopManager.hit_stop_enemy_comboed()

		if not is_stunned:
			velocity.y = -370

		is_stunned = true

		await get_tree().create_timer(2.5).timeout

		is_stunned = false

	if area.is_in_group("player_attack_combo_2"):
		HitstopManager.hit_stop_enemy_comboed()

		is_stunned = true
		velocity.y = 200

		await get_tree().create_timer(2.5).timeout

		is_stunned = false

	if area.is_in_group("player_attack_combo_3"):
		HitstopManager.hit_stop_enemy_comboed()

		var player = area.owner

		is_stunned = true
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



	collision_hitbox.set_deferred("disabled", true)

	await get_tree().create_timer(0.2).timeout

	velocity = Vector2.ZERO

	await get_tree().create_timer(3.5).timeout

	collision_hitbox.set_deferred("disabled", false)


	is_stunned = false


func down_hit(player_dir: int) -> void:
	is_stunned = true

	velocity.y = -450
	velocity.x = player_dir * 250



	collision_hitbox.set_deferred("disabled", true)

	await get_tree().create_timer(0.2).timeout

	velocity = Vector2.ZERO

	await get_tree().create_timer(3.5).timeout

	collision_hitbox.set_deferred("disabled", false)



	is_stunned = false


func up_hit() -> void:
	is_stunned = true

	velocity.y = -750
	velocity.x = 0



	collision_hitbox.set_deferred("disabled", true)

	await get_tree().create_timer(0.2).timeout

	velocity = Vector2.ZERO

	await get_tree().create_timer(1.2).timeout

	collision_hitbox.set_deferred("disabled", false)



	is_stunned = false
