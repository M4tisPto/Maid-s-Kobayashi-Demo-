class_name Enemy
extends CharacterBody2D
@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed := 100
@onready var ground_check: RayCast2D = $GroundRay
@onready var collision_hitbox: CollisionShape2D = $Hitbox/collision_hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var health = 2
var direction := -1
var player_grab_node: Node2D = null
var grabbed := false # this is a placeholder

func _ready() -> void: 
	update_raycast_direction()


func _physics_process(delta: float) -> void: 
	if grabbed:
		if is_instance_valid(player_grab_node):
			collision_hitbox.set_deferred("disabled", true)
			global_position = player_grab_node.global_position
		return
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * speed
	move_and_slide()
		
	if is_on_floor(): 
		if is_on_wall() or !ground_check.is_colliding(): 
			direction *= -1 
			update_raycast_direction() 

func take_damage(ammount: float):
	health -= ammount
	print("damage left: ", health)
	
	if health <= 0:
		die()
func die():
	var player = get_tree().get_first_node_in_group("player")
	PlayerManager.shake_camera(2, 0.2)
	get_parent().queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		take_damage(1)
	if area.is_in_group("player_grab"):
		
		var player = area.get_parent()
		if player.get("enemy_grabbed") == true:
			return
		
		if player:
			player.enemy_grabbed = true
		velocity.x = 0
		grabbed = true
		if player and player.has_node("GrabPosition"):
			player_grab_node = player.get_node("GrabPosition")
		else:
			player_grab_node = area

func _on_hurtbox_area_exited(area: Area2D) -> void:
	if grabbed:
		grabbed = false
		player_grab_node = null
		var player = area.get_parent()
		if player:
			player.enemy_grabbed = false
			direction *= -1 
			update_raycast_direction()
	
	animation_player.play("enemy_blink_dragged_out")

func update_raycast_direction(): 
	ground_check.target_position = Vector2(direction * 20, 20)
