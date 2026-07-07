extends Node2D
class_name  ArmManager
@export var arms_list: Array[ArmsResource] = []

@onready var shoot_point: Marker2D = $Marker2D
@onready var cooldown_timer: Timer = $Timer

var current_index: int = 0
var arm_equiped: ArmsResource = null
var player: Player
func _ready() -> void:
	player = get_parent() as Player
	if arms_list.size() > 0:
		equip_arm(0) # default one

# For testing!
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("test"):
		next_arm()
	if Input.is_action_just_pressed("attack") and cooldown_timer.is_stopped():
		run_attack()


func equip_arm(index: int) -> void:
	current_index = index
	arm_equiped = arms_list[current_index]


func next_arm() -> void:
	if arms_list.size() == 0: return
	var new_index = (current_index + 	1) % arms_list.size()
	equip_arm(new_index)

func run_attack() -> void:
	if arm_equiped == null or arm_equiped.attack_scene == null: return
	cooldown_timer.start(arm_equiped.timer_await)
	
	var attack = arm_equiped.attack_scene.instantiate()
	attack.global_position = shoot_point.global_position
	
