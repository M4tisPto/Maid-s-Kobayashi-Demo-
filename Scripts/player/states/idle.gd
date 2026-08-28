extends State
# movement idle 
@export var fall_state: State
@export var jump_state: State
@export var hurt_state: State
@export var duck_state: State
@export var walk_state: State
@export var run_state: State #

var current_gravity = gravity
var last_tap_time: float = -1.0
var last_tap_direction: int = 0
var double_tap_delay: float = 0.4
func enter() -> void:
	print("Idle state enter")

	parent.sophia_animations.play("idle")
	parent.jumps_left = parent.TOTAL_JUMPS
	parent.velocity.x = 0


	parent.dash_activated = true

func process_input(event: InputEvent) -> State:

	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state

	if Input.is_action_pressed("duck_down"):
		return duck_state

	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):

		var current_time := Time.get_ticks_msec() / 1000.0
		var direction := 0

		if event.is_action_pressed("move_left"):
			direction = -1
		elif event.is_action_pressed("move_right"):
			direction = 1

		if direction == last_tap_direction \
		and current_time - last_tap_time <= double_tap_delay:

			last_tap_time = -1.0
			last_tap_direction = 0

			parent.facing_direction = direction

			return run_state

		last_tap_time = current_time
		last_tap_direction = direction

		return walk_state

	return null
func process_physics(delta: float) -> State:
	if parent.velocity.y > 0:
		parent.is_wave_boosting = false
		
	if not parent.is_on_floor():
		parent.velocity.y += gravity * delta
	elif not parent.is_wave_boosting:
		parent.velocity.y = 0
		
	if parent.spin_jump_requested:
		return jump_state
		
	parent.move_and_slide()
	
	if not parent.is_on_floor():
		return fall_state
		
	return null
