extends CharacterBody2D
# enemy script

@export var gravity = 900
@export var speed = 75
@onready var ground_check: RayCast2D = $GroundRay
@onready var hurtbox: CollisionShape2D = $CopyArea/CollisionShape2D
@onready var knuckle_hitbox: CollisionShape2D = $flip_area/Hitbox/CollisionShape2D
@onready var copy_area: CollisionShape2D = $CopyArea/CollisionShape2D
@onready var flip_area: Node2D = $flip_area
@export var close_distance = 45.0
@onready var player: Player = $"../../player"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var collision_shockwave: CollisionShape2D = $flip_area/Hitbox/shockwave/collision_shockwave
@onready var collision_hitbox: CollisionShape2D = $flip_area/Hitbox/CollisionShape2D


@onready var attack_knuc: AnimationPlayer = $flip_area/Hitbox/AnimationPlayer

var is_player_near = false
var gotta_attack = false

var facing_direction := 1:
	set(value):
		if value != 0 and value != facing_direction:
			facing_direction = value
			flip_area.scale.x = facing_direction
			sprite.flip_h = facing_direction == -1

func _ready() -> void:
	
	ground_check.add_exception(self)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_player_near and not gotta_attack:
		knuck_attacking()
	if not gotta_attack:
		if (is_on_floor() and not ground_check.is_colliding()) or is_on_wall():
			facing_direction = facing_direction
			ground_check.target_position = Vector2(facing_direction * 20, 20)

		if player.global_position.x > global_position.x:
			facing_direction = 1
		else:
			facing_direction = -1
		velocity.x = facing_direction * speed
	else:
		velocity.x = 0
	move_and_slide()

func knuck_attacking() -> void:
	gotta_attack = true
	sprite.play("charging")
	await  get_tree().create_timer(0.50).timeout
	attack_knuc.play("knuck_attack")
	await  get_tree().create_timer(0.305).timeout
	$flip_area/Hitbox/shockwave/AnimationPlayer.play("shockwave")
	await get_tree().create_timer(0.636).timeout
	sprite.play("walking")
	gotta_attack = false


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_player_near = true
		print("ready to attack")
	


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body == player:
		is_player_near = false
		print("not anymore")


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("knuckle_attack_player"):
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


func neutral_hit(player_dir: int) -> void:
	sprite.play("hurt")
	velocity.x = player_dir * 550
	velocity.y = -150
	collision_hitbox.set_deferred("disabled", true)
	await get_tree().create_timer(0.05).timeout
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.8).timeout
	collision_hitbox.set_deferred("disabled", false)
	sprite.play("walking")



func side_hit(player_dir: int) -> void:
	sprite.play("hurt")
	velocity.y = -250
	velocity.x = player_dir * 900
	collision_hitbox.set_deferred("disabled", true)
	await get_tree().create_timer(0.15).timeout
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.6).timeout
	collision_hitbox.set_deferred("disabled", false)
	sprite.play("walking")
