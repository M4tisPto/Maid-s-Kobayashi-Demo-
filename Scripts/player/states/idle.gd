extends State
# movement idle 
@export var fall_state: State
@export var jump_state: State
@export var move_state: State
@export var hurt_state: State
@export var duck_state: State

var current_gravity = gravity

func enter() -> void:
	print("Idle state enter")
	parent.jumps_left = parent.TOTAL_JUMPS
	parent.velocity.x = 0


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
		
	if Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right'):
		return move_state
		
	
	if Input.is_action_pressed("duck_down"):
		return duck_state

	return null
func process_physics(delta: float) -> State:
	if parent.velocity.y > 0:
		parent.is_wave_boosting = false

	if not parent.is_on_floor():
		parent.velocity.y += gravity * delta
	elif not parent.is_wave_boosting:
		parent.velocity.y = 0
		
	parent.move_and_slide()
	
	if not parent.is_on_floor():
		return fall_state
		
	return null
