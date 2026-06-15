class_name Player
extends CharacterBody2D

@export var max_hp: int = 100
@onready var current_hp: int = max_hp
@onready var movement_state_machine: Node = $movement_state_machine
@onready var attack_state_machine: Node = $attack_state_machine
@onready var collision_hitbox: CollisionShape2D = $Hitbox/collision_hitbox

@export var rotation_speed = 10.0
@onready var player_model: Node3D = $SubViewport/Sophia_Model
var facing_direction := 1
var jumps_left: int = 0
const TOTAL_JUMPS: int = 2


func _ready() -> void:
	movement_state_machine.init(self)
	attack_state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	movement_state_machine.process_input(event)
	attack_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
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
