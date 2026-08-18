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


@onready var attack_knuc: AnimationPlayer = $flip_area/Hitbox/AnimationPlayer

var is_player_near = false
var gotta_attack = false

var facing_direction := 1:
	set(value):
		if value != 0 and value != facing_direction:
			facing_direction = value
			flip_area.scale.x = -facing_direction

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
	attack_knuc.play("knuck_attack")
	await  get_tree().create_timer(0.7).timeout
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



	
