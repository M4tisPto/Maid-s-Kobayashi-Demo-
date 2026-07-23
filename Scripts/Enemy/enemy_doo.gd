#enemy script

class_name Enemy extends CharacterBody2D

@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed := 100
@export var shake_decay = 15.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var ground_check: RayCast2D = $GroundRay
@onready var collision_hitbox: CollisionShape2D = $Hitbox/collision_hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var direction = 1
var is_stunned = false
var shake_strength: float = 0.0
var initial_offset: Vector2   
func _ready() -> void:
	initial_offset = sprite.offset 
	update_raycast_direction()

func _process(delta: float) -> void:
	if shake_strength > 0:
		sprite.offset = initial_offset + Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		sprite.offset = initial_offset

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += gravity * delta
	if not is_stunned:
		velocity.x = direction * speed
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, speed * delta * 51)

	move_and_slide()
	
	if not is_stunned:
		if is_on_wall() or not ground_check.is_colliding():
			direction *= -1
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
		shockwave_hit()
func neutral_hit(player_dir: int) -> void:
	is_stunned = true
	velocity.x = player_dir * 550
	velocity.y = -50
	collision_hitbox.set_deferred("disabled", true)
	await get_tree().create_timer(0.05).timeout
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.6).timeout
	collision_hitbox.set_deferred("disabled", false)
	is_stunned = false

func side_hit(player_dir: int) -> void:
	is_stunned = true
	velocity.x = player_dir * 900
	velocity.y = -200
	collision_hitbox.set_deferred("disabled", true)
	await get_tree().create_timer(0.15).timeout
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.6).timeout
	collision_hitbox.set_deferred("disabled", false)
	is_stunned = false
func shockwave_hit() -> void:
	is_stunned = true
	velocity.y = -650
	velocity.x = 0
	animation_player.play("enemy_stunned_or_some_shi")
	collision_hitbox.set_deferred("disabled", true)
	
	await get_tree().create_timer(0.2).timeout
	while not is_on_floor():
		await get_tree().physics_frame
	apply_shake(25.0) 
	
	await get_tree().create_timer(1.5).timeout
	collision_hitbox.set_deferred("disabled", false)
	animation_player.play("RESET")
	is_stunned = false
func update_raycast_direction() -> void:
	ground_check.target_position = Vector2(direction * 20, 20)

func apply_shake(strength: float):
	shake_strength = strength
