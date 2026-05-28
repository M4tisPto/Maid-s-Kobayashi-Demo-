class_name Player
extends CharacterBody2D

@onready
var state_machine = $state_machine
@export var rotation_speed = 10.0
@onready var player_model: Node3D = $SubViewport/Sophia_Model
var facing_direction := 1
var jumps_left: int = 0
@export
var TOTAL_JUMPS: int = 2



func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
