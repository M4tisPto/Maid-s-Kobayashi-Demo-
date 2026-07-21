extends State
var arm_animation_player: AnimationPlayer
@export var jump_boost = 600
var boost_air = 200
func enter() -> void:
	print("down")
	parent.wave_boost -= 1
	parent.is_wave_boosting = true
	if parent.is_on_floor():
		parent.velocity.y = -jump_boost
	else:
		parent.velocity.y = -jump_boost + boost_air
	
	parent.move_and_slide()
func process_physics(_delta: float) -> State:
	return get_parent() as State

func exit() -> void:
	parent.is_wave_boosting = false
