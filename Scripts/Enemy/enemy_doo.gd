class_name Enemy extends CharacterBody2D

@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed := 100
@export var jump_stunned = 500
@export var stun_duration: float = 3.0
@export var push_shockwaved: Vector2 = Vector2.ZERO
@export var push_timer := 0.0

@export var shake_amount = 8.0
@export var shake_decay = 3.0
@export var stun_timer: float = 15.0
@export var force := 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var ground_check: RayCast2D = $GroundRay
@onready var collision_hitbox: CollisionShape2D = $Hitbox/collision_hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var shockwaved = false
var is_stunned = false
var direction := -1
var current_shake = 0.0
var original_position: Vector2

func _ready() -> void:
	original_position = position
	update_raycast_direction()

func _physics_process(delta: float) -> void:
	if is_stunned:
		collision_hitbox.set_deferred("disabled", true)
		velocity.x = 0
		stun_timer -= delta
		if is_on_floor():
			var shake_limit = shake_amount if stun_timer > 0 else 0.0
			current_shake = lerp(current_shake, shake_limit, shake_decay * delta)
			sprite.offset = Vector2(randf_range(-current_shake, current_shake), randf_range(-current_shake, current_shake))
	elif shockwaved:
		if push_timer > 0.0:
			velocity.x = -push_shockwaved.x * 120
			push_timer -= delta
		else:
			if is_on_floor():
				shockwaved = false
	else:
		collision_hitbox.set_deferred("disabled", false)
		velocity.x = direction * speed
		if animation_player.current_animation == "enemy_stunned_or_some_shi":
			animation_player.play("RESET")

	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()
		
	if is_on_floor() and not is_stunned:
		if is_on_wall() or not ground_check.is_colliding():
			direction *= -1
			update_raycast_direction()

# Stunned mechanic
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if is_stunned and area.is_in_group("player_spin") and not is_on_floor():
		animation_player.play("another_hit_for_me_exclametion_mark")
		velocity.y = -jump_stunned
		stun_timer = stun_duration + 1.5
		return
		
	if area.is_in_group("knuckle_attack_player") and not is_stunned:
		shockwaved = true
		
		push_shockwaved.x = direction * force
		push_timer = 0.5
		await get_tree().create_timer(0.2).timeout
		
	if area.is_in_group("shockwave_player"):
		animation_player.play("another_hit_for_me_exclametion_mark")
		shockwaved = true
		push_shockwaved.x = direction * force
		push_timer = 0.5
		velocity.y = -jump_stunned * 1.2

func update_raycast_direction() -> void:
	ground_check.target_position = Vector2(direction * 20, 20)
