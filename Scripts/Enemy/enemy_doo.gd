class_name Enemy
extends CharacterBody2D

@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed := 100
@export var jump_stunned = 500
@export var stun_duration: float = 3.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var ground_check: RayCast2D = $GroundRay
@onready var collision_hitbox: CollisionShape2D = $Hitbox/collision_hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_stunned = false
var direction := -1
var stun_timer: float = 0.0

func _ready() -> void: 
	update_raycast_direction()

func _physics_process(delta: float) -> void: 
	if is_stunned:
		collision_hitbox.set_deferred("disabled", true)
		velocity.x = 0
		stun_timer -= delta
		if stun_timer <= 0.0:
			is_stunned = false
			animation_player.play("RESET")
	else:
		collision_hitbox.set_deferred("disabled", false)
		velocity.x = direction * speed
		if animation_player.current_animation == "enemy_stunned_or_some_shi":
			animation_player.play("RESET")

	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()
		
	if is_on_floor() and not is_stunned: 
		if is_on_wall() or !ground_check.is_colliding(): 
			direction *= -1 
			update_raycast_direction() 


# stunned mechanic
func _on_hurtbox_area_entered(area):
	if is_stunned and area.is_in_group("player_spin") and not is_on_floor():
		animation_player.play("another_hit_for_me_exclametion_mark")
		velocity.y = -jump_stunned
		stun_timer = stun_duration + 1.5
		return
	if area.is_in_group("player_heavy_weapons_guy_attack") and not is_stunned:
		print("hola")
		is_stunned = true
		stun_timer = stun_duration
		animation_player.play("enemy_stunned_or_some_shi")
		# intentando hacer un combo

		await get_tree().create_timer(0.2).timeout
		velocity.y = -jump_stunned

func update_raycast_direction(): 
	ground_check.target_position = Vector2(direction * 20, 20)
