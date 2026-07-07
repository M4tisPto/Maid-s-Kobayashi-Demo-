class_name Player
extends CharacterBody2D
@export var fall_gravity_multiplier := 2.0
@export var max_hp: int = 100
@onready var current_hp: int = max_hp
@onready var movement_state_machine: Node = $movement_state_machine
@onready var attack_state_machine: Node = $attack_state_machine 
@onready var spin_attack: AnimationPlayer = $Hitbox/spin_attack
@onready var collision_hitbox: CollisionShape2D = $Hitbox/collision_hitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var camera_manager: Camera2D = $CameraManager
@onready var health_component: Node2D = $HealthComponent
@export var invulnerability_duration: float = 0.75
var invisible:= false
@export var hurt_state: State 
var spin_jump_requested := false
@export var rotation_speed = 10.0
@onready var player_model: Node3D = $SubViewport/Sophia_Model
var facing_direction := 1
var jumps_left: int = 0
const TOTAL_JUMPS: int = 2
var knockback_velocity = Vector2.ZERO


	

var _is_dead := false

var is_dead: bool:
	set(value):
		if _is_dead == value:
			return

		_is_dead = value

		if _is_dead:
			await HitstopManager.hit_stop_death()
			Engine.time_scale = 1.0
			get_tree().reload_current_scene()

	get:
		return _is_dead

func _ready() -> void:
	add_to_group("player")
	movement_state_machine.init(self)
	attack_state_machine.init(self)
	health_component.died.connect(die)


func die():
	if is_dead:
		return

	is_dead = true
	set_physics_process(false)

	print("Jugador muerto")

func start_invulnerability_timer():
	await get_tree().create_timer(invulnerability_duration).timeout
	
	invisible = false
	hurtbox.set_deferred("monitoring", true)
	print("u can get hurt again now")


func _unhandled_input(event: InputEvent) -> void:
	movement_state_machine.process_input(event)
	attack_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		movement_state_machine.change_state(hurt_state)
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	movement_state_machine.process_physics(delta)
	attack_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)
	attack_state_machine.process_frame(delta)

func update_attack_hitbox():
	if facing_direction == 1:
		collision_hitbox.position.x = 45
	else:
		collision_hitbox.position.x = -45



func _on_hurtbox_area_entered(area: Area2D) -> void:
	if _is_dead or invisible:
		return
	if area.is_in_group("enemy_hitbox"):
		health_component.damage(area.ammount, area.strenght)
	
	var impact_dir = 1.0
	if area.global_position.x > global_position.x:
		impact_dir = -1.0
	
	var knockback_vector = Vector2(impact_dir, -0.2).normalized()
	
	HitstopManager.hit_stop_hurt()
	if movement_state_machine.current_state == hurt_state:
		return
	knockback_velocity = knockback_vector * 1.5 * 200
	movement_state_machine.change_state(hurt_state)
