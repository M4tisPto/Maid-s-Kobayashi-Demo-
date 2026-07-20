extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
func enter():
	print("Move state enter")

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta

	var movement = Input.get_axis("move_left", "move_right") * move_speed
	if movement != 0:
		parent.facing_direction = sign(movement)
		parent.velocity.x = movement
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, move_speed)

	if movement == 0:
		return idle_state

	parent.move_and_slide()
	

	if !parent.is_on_floor():
		return fall_state

	return null
