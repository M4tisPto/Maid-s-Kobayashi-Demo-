extends State

@export var idle_state: State
@export var jump_state: State
@export var run_state: State
@export var fall_state: State


func enter() -> void:
	print("walk state")
	parent.sophia_animations.play("walkin")

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	if parent.spin_jump_requested:
		return jump_state
		
	parent.velocity.y += gravity * delta
	var movement = Input.get_axis("move_left", "move_right") * move_speed
	
	if movement != 0:
		parent.sophia_animations.flip_h = movement < 0
		parent.facing_direction = sign(movement)
		parent.velocity.x = movement
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, move_speed)
		
	parent.move_and_slide()
	if not parent.is_on_floor():
		return fall_state

	if movement == 0 and is_zero_approx(parent.velocity.x):
		return idle_state

	return null
