extends State

@export var fall_state: State
@export var idle_state: State
@export var jump_state: State
@export var skid_state: State

@export var acceleration: float = 1500.0
@export var friction: float = 1100.0
@export var turn_acceleration: float = 7000.0

@export var run_boost_speed: float = 700.0
@export var run_boost_time: float = 0.08

var boost_timer: float = 0.0


func enter() -> void:
	if parent.dash_activated:
		boost_timer = run_boost_time
		parent.velocity.x = parent.facing_direction * run_boost_speed
		parent.dash_activated = false
	else:
		boost_timer = 0.0

	parent.sophia_animations.animation_finished.connect(
		_on_animation_finished,
		CONNECT_ONE_SHOT
	)

	parent.sophia_animations.play("run_start")


func exit() -> void:
	if parent.sophia_animations.animation_finished.is_connected(_on_animation_finished):
		parent.sophia_animations.animation_finished.disconnect(_on_animation_finished)


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state

	return null


func _on_animation_finished() -> void:
	if parent.sophia_animations.animation == "run_start":
		parent.sophia_animations.play("run_loop")


func process_physics(delta: float) -> State:
	if parent.spin_jump_requested:
		return jump_state

	parent.velocity.y += gravity * delta

	var input := Input.get_axis("move_left", "move_right")

	if boost_timer > 0.0:
		boost_timer -= delta

		if input != 0:
			parent.facing_direction = sign(input)
			parent.sophia_animations.flip_h = input < 0

			parent.velocity.x = move_toward(
				parent.velocity.x,
				input * run_boost_speed,
				turn_acceleration * delta
			)
		else:
			parent.velocity.x = parent.facing_direction * run_boost_speed

	else:
		if input != 0:
			var target_speed := input * move_speed

			if sign(parent.velocity.x) != sign(target_speed) \
			and not is_zero_approx(parent.velocity.x):
				parent.skid_direction = sign(input)
				return skid_state

			parent.sophia_animations.flip_h = input < 0
			parent.facing_direction = sign(input)

			parent.velocity.x = move_toward(
				parent.velocity.x,
				target_speed,
				acceleration * delta
			)

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
