extends State
# movement walk

@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var run_state: State

@export var acceleration: float = 1200.0
@export var friction: float = 1000.0
@export var turn_acceleration: float = 1800.0

func enter() -> void:
	print("walk state")
	parent.sophia_animations.play("walkin")


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state

	return null


func process_physics(delta: float) -> State:
	if parent.spin_jump_requested:
		return jump_state

	parent.velocity.y += gravity * delta

	var input := Input.get_axis("move_left", "move_right")

	if input != 0:
		var target_speed := input * move_speed

		if sign(parent.velocity.x) != sign(target_speed) and not is_zero_approx(parent.velocity.x):
			parent.velocity.x = move_toward(
				parent.velocity.x,
				target_speed,
				turn_acceleration * delta
			)
		else:
			parent.velocity.x = move_toward(
				parent.velocity.x,
				target_speed,
				acceleration * delta
			)

		parent.sophia_animations.flip_h = input < 0
		parent.facing_direction = sign(input)

	else:
		parent.velocity.x = move_toward(
			parent.velocity.x,
			0.0,
			friction * delta
		)

	parent.move_and_slide()

	if not parent.is_on_floor():
		return fall_state

	if input == 0 and is_zero_approx(parent.velocity.x):
		return idle_state

	return null
