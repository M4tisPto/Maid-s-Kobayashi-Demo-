extends State

@export var idle_state: State
@export var fall_state: State 
func enter() -> void:
	print("ducked down")
	parent.animation_player.play("ducked")

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_released("duck_down"):
		parent.animation_player.play("RESET")
		return idle_state
	return null

func process_physics(delta: float) -> State:
	if parent.velocity.y > 0:
		parent.is_wave_boosting = false
	
	if not parent.is_on_floor():
		parent.velocity.y += gravity * delta
	elif not parent.is_wave_boosting:
		parent.velocity.y = 0
	if not parent.is_on_floor():
		parent.animation_player.play("RESET")
		return fall_state
	return null
