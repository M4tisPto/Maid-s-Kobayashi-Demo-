extends CharacterBody2D

@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed := 400

@onready var collision_hitbox: CollisionShape2D = $Hitbox/collision_hitbox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_hurtbox: CollisionShape2D = $Hurtbox/collision_hurtbox
@onready var main_collision: CollisionShape2D = $collision

var direction = 1
var last_collision_state: bool = false
var hit_wall_stunned = false

func _ready() -> void:
	sprite.flip_h = direction == 1
	update_collisions_visibility()

func _physics_process(delta: float) -> void:
	if last_collision_state != GameManager.is_collisions_checked:
		update_collisions_visibility()
		
	if hit_wall_stunned:
		move_and_slide()
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		
	if is_on_wall() and not hit_wall_stunned:
		trigger_wall_stun()
	else:
		if not hit_wall_stunned:
			sprite.play("walkin")
		
	velocity.x = direction * speed
	move_and_slide()

# bump on wall on opposite direction but goes flying up and hittiing between walls for some reasons
func trigger_wall_stun() -> void:
	if hit_wall_stunned:
		return # Prevent re-triggering while already stunned
		
	hit_wall_stunned = true
	direction *= -1 # Flip direction first so we push AWAY from the wall
	sprite.flip_h = direction == 1
	
	velocity.x = direction * 400 # Match normal speed or slight boost
	velocity.y = -50 # Controlled upward pop
	
	sprite.play("hurt")
	
	await get_tree().create_timer(0.5).timeout # Shorter stun often feels better
	hit_wall_stunned = false


func update_collisions_visibility() -> void:
	last_collision_state = GameManager.is_collisions_checked
	main_collision.visible = last_collision_state
	collision_hitbox.visible = last_collision_state
	collision_hurtbox.visible = last_collision_state
