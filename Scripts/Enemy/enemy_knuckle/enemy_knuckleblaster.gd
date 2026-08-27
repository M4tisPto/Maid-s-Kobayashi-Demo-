extends CharacterBody2D
# enemy script

@export var gravity = 900
@export var speed = 75

@export var close_distance := 45.0
@export var stun_duration := 0.7
@export var stun_knockback := 100.0

@onready var ground_check: RayCast2D = $GroundRay
@onready var hurtbox: CollisionShape2D = $CopyArea/CollisionShape2D
@onready var knuckle_hitbox: CollisionShape2D = $flip_area/Hitbox/CollisionShape2D
@onready var copy_area: CollisionShape2D = $CopyArea/CollisionShape2D
@onready var flip_area: Node2D = $flip_area

@onready var player: Player = $"../../player"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var collision_hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var collision_shockwave: CollisionShape2D = $flip_area/Hitbox/shockwave/collision_shockwave
@onready var collision_hitbox: CollisionShape2D = $flip_area/Hitbox/CollisionShape2D

@onready var attack_knuc: AnimationPlayer = $flip_area/Hitbox/AnimationPlayer
@onready var shockwave_animation: AnimationPlayer = $flip_area/Hitbox/shockwave/AnimationPlayer


var is_player_near := false
var gotta_attack := false
var is_stunned := false


var facing_direction := 1:
	set(value):
		if value != 0 and value != facing_direction:
			facing_direction = value
			flip_area.scale.x = facing_direction
			sprite.flip_h = facing_direction == -1


func _ready() -> void:
	if GameManager.is_collisions_checked:
		$CollisionShape2D.visible = true
		$Hurtbox/CollisionShape2D.visible = true
		$CopyArea/CollisionShape2D.visible = true
		$flip_area/Hitbox/CollisionShape2D.visible = true
		$flip_area/Hitbox/shockwave/collision_shockwave.visible = true
		$DetectArea/CollisionShape2D.visible = true
		$GroundRay.visible = true
	else:
		$CollisionShape2D.visible = false
		$Hurtbox/CollisionShape2D.visible = false
		$CopyArea/CollisionShape2D.visible = false
		$flip_area/Hitbox/CollisionShape2D.visible = false
		$flip_area/Hitbox/shockwave/collision_shockwave.visible = false
		$DetectArea/CollisionShape2D.visible = false
		$GroundRay.visible = false
	ground_check.add_exception(self)


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += gravity * delta



	if is_stunned:
		# No puede moverse normalmente
		velocity.x = move_toward(
			velocity.x,
			0.0,
			speed * 8.0 * delta
		)

		move_and_slide()
		return



	if gotta_attack:
		move_and_slide()
		return



	if is_player_near:
		knuck_attacking()
		move_and_slide()
		return



	if (is_on_floor() and not ground_check.is_colliding()) or is_on_wall():
		ground_check.target_position = Vector2(
			facing_direction * 20,
			20
		)

	# Mirar hacia el jugador
	if player.global_position.x > global_position.x:
		facing_direction = 1
	else:
		facing_direction = -1

	velocity.x = facing_direction * speed

	move_and_slide()

func knuck_attacking() -> void:

	# Evitar iniciar otro ataque
	if gotta_attack or is_stunned:
		return

	gotta_attack = true

	sprite.play("charging")


	# -----------------------------------------
	# CARGA
	# -----------------------------------------

	await get_tree().create_timer(0.50).timeout

	# Si fue golpeado durante la carga
	if is_stunned:
		gotta_attack = false
		return


	# -----------------------------------------
	# ATAQUE
	# -----------------------------------------

	attack_knuc.play("knuck_attack")


	await get_tree().create_timer(0.305).timeout

	# Si fue golpeado durante el ataque
	if is_stunned:
		gotta_attack = false
		return


	# -----------------------------------------
	# SHOCKWAVE
	# -----------------------------------------

	shockwave_animation.play("shockwave")


	await get_tree().create_timer(0.636).timeout

	# Si fue golpeado durante el shockwave
	if is_stunned:
		gotta_attack = false
		return


	# -----------------------------------------
	# TERMINAR ATAQUE
	# -----------------------------------------

	sprite.play("walking")
	gotta_attack = false


# =========================================================
# DETECCIÓN DEL JUGADOR
# =========================================================

func _on_detect_area_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		player = body
		is_player_near = true

		print("ready to attack")


func _on_detect_area_body_exited(body: Node2D) -> void:

	if body == player:
		is_player_near = false

		print("not anymore")


# =========================================================
# HURTBOX
# =========================================================

func _on_hurtbox_area_entered(area: Area2D) -> void:

	# ==========================================
	# KNUCKLEBLASTER
	# ==========================================

	if area.is_in_group("knuckle_attack_player"):

		var attacking_player = area.owner

		if attacking_player == null:
			return

		var kb_arm = attacking_player.get_node_or_null(
			"arm_state_machine/knuckleblaster_arm"
		)

		if kb_arm and kb_arm.current_sub_state:

			match kb_arm.current_sub_state.name:

				"neutral":
					print("neutral?")
					neutral_hit(attacking_player.facing_direction)

				"side":
					print("side?")
					side_hit(attacking_player.facing_direction)




	if area.is_in_group("player_attack_combo_1"):

		var attacking_player = area.owner

		if attacking_player == null:
			return

		stun(attacking_player.facing_direction)
	if area.is_in_group("player_attack_combo_2"):

		var attacking_player = area.owner

		if attacking_player == null:
			return

		stun(attacking_player.facing_direction)
	if area.is_in_group("player_attack_combo_3"):

		var attacking_player = area.owner

		if attacking_player == null:
			return

		stun(attacking_player.facing_direction)
func stun(player_dir: int) -> void:

	if is_stunned:
		return

	is_stunned = true


	gotta_attack = false




	attack_knuc.stop()
	shockwave_animation.stop()



	collision_hitbox.set_deferred("disabled", true)
	collision_shockwave.set_deferred("disabled", true)



	sprite.play("hurt")



	velocity.x = player_dir * stun_knockback
	velocity.y = -40.0



	await get_tree().create_timer(stun_duration).timeout


	is_stunned = false

	collision_hitbox.set_deferred("disabled", false)

	sprite.play("walking")
	


func neutral_hit(player_dir: int) -> void:

	if is_stunned:
		return

	sprite.play("hurt")

	velocity.x = player_dir * 550
	velocity.y = -150

	collision_hitbox.set_deferred("disabled", true)

	await get_tree().create_timer(0.05).timeout

	velocity = Vector2.ZERO

	await get_tree().create_timer(0.8).timeout

	collision_hitbox.set_deferred("disabled", false)

	if not is_stunned:
		sprite.play("walking")


func side_hit(player_dir: int) -> void:
	if is_stunned:
		return

	sprite.play("hurt")

	velocity.y = -250
	velocity.x = player_dir * 900

	collision_hitbox.set_deferred("disabled", true)

	await get_tree().create_timer(0.15).timeout

	velocity = Vector2.ZERO

	await get_tree().create_timer(0.6).timeout

	collision_hitbox.set_deferred("disabled", false)

	if not is_stunned:
		sprite.play("walking")
