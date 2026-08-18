extends State
# movement fall

@export var idle_state: State
@export var move_state: State
@export var jump_state: State
var _is_spinning: bool = false
func enter() -> void:
	if parent.jumps_left == parent.TOTAL_JUMPS:
		parent.jumps_left -= 1
	_is_spinning = parent.spin_jump_requested
	if _is_spinning:
		parent.sophia_animations.play("spin_jump")
		if parent.animation_player.has_animation("spin_attack"):
			parent.animation_player.play("spin_attack")
	else:
		parent.sophia_animations.play("fall")
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
	
	if Input.is_action_just_pressed("jump") and parent.jumps_left > 0:
		parent.jumps_left -= 1
		print("Total jumps: " + str(parent.jumps_left))
		AudioController.play_sound("jump")
		return jump_state
		
	
	if parent.is_on_floor():
		parent.jumps_left = parent.TOTAL_JUMPS
		if movement != 0:
			return move_state
		return idle_state
		
	return null
