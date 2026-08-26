extends State
# movement jump

@export var fall_state: State
@export var idle_state: State
@export var move_state: State
@export var jump_force: float = 900.0
var spin_jump_boost = 600.0

func enter():
	print("Jump state enter")

	if parent.spin_jump_requested and parent.is_on_floor():
		parent.velocity.y = -spin_jump_boost
		parent.spin_jump_requested = false
	elif parent.spin_jump_requested and not parent.is_on_floor():
		parent.velocity.y = -spin_jump_boost / 1.5
		parent.spin_jump_requested = false
	else:
		parent.sophia_animations.play("jump")
		parent.velocity.y = -jump_force

func process_physics(delta: float) -> State:

	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("move_left", "move_right") * move_speed
	if movement != 0:
		parent.sophia_animations.flip_h = movement < 0
		parent.facing_direction = sign(movement)
		parent.velocity.x = movement
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, move_speed)


	# Mecánica de saltos extras (Doble salto)
	if Input.is_action_just_pressed("jump") and parent.jumps_left > 0:
		AudioController.play_sound("jump")
		parent.velocity.y = -jump_force * 1.2 # Fuerza fija para evitar tirones acumulativos
		parent.jumps_left -= 1
		print("Total jumps: " + str(parent.jumps_left))
		
	if Input.is_action_just_released("jump") and parent.velocity.y < 0:
		parent.velocity.y *= 0.5
		
	parent.move_and_slide()
	
	
	if parent.velocity.y > 0:
		return fall_state
	
	if parent.is_on_floor():
		parent.jumps_left = parent.TOTAL_JUMPS
		if movement != 0:
			return move_state
		return idle_state

	return null
