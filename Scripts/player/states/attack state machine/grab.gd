extends State

@export var idle_state: State
@export var move_state: State
@export var fall_state: State

var timer := 0.2

func enter():
	timer = 0.2
	parent.velocity.x = 0

func process_physics(delta):

	timer -= delta

	parent.move_and_slide()

	if timer <= 0:

		if !parent.is_on_floor():
			return fall_state

		if abs(parent.velocity.x) > 0:
			return move_state

		return idle_state

	return null
