extends State
@export var idle_state: State
var bullet_path = preload("res://Scenes/bullet.tscn")
var timer = 0.0 # temp

func enter() -> void:
	timer = 0.5
	print("imma shootin'")
	var bullet_instance = parent.bullet.instantiate() as Node2D
	bullet_instance.direction = parent.facing_direction
	bullet_instance.global_position = parent.muzzle.global_position
	get_parent().add_child(bullet_instance)

func process_physics(delta: float) -> State:
	timer -= delta
	if timer > 0:
		return idle_state
	return null
