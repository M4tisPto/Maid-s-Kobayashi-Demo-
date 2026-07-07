extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State


@export
var jump_force: float = 900.0



func enter():
	print("Jump state enter")
	
	parent.velocity.y = -jump_force

func process_physics(delta: float) -> State:
	if parent.spin_jump_requested:
		parent.velocity.y = -400.0
		parent.spin_jump_requested = false
	
	parent.velocity.y += gravity * delta
	if parent.velocity.y > 0:
		return fall_state
	
	var movement = Input.get_axis("move_left", "move_right") * move_speed
	if movement > 0:
		parent.facing_direction = 1
		parent.update_attack_hitbox()
	elif movement < 0:
		parent.facing_direction = -1
		parent.update_attack_hitbox()
	if movement != 0:
		var target_rotation = PI/3 if movement > 0 else -PI/3
		parent.player_model.rotation.y = lerp_angle(
			parent.player_model.rotation.y,
			target_rotation,
			parent.rotation_speed * delta
		)
	parent.velocity.x = movement
	if Input.is_action_just_pressed("jump") and parent.jumps_left > 0:
		AudioController.play_sound("jump")
		parent.velocity.y *= 1.2
		parent.jumps_left -= 1
		print("Total jumps: " + str(parent.jumps_left))
	if Input.is_action_just_released("jump"):
		parent.velocity.y *= 0.5
		return fall_state
	parent.move_and_slide()
	
	if parent.is_on_floor():
		parent.jumps_left = parent.TOTAL_JUMPS
		if movement != 0:
			return move_state
		return idle_state

	return null
