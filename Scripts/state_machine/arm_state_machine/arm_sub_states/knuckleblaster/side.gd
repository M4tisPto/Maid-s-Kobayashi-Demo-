extends State

var arm_animation_player: AnimationPlayer

var dash_speed := 450.0 
var dash_duration := 0.25 
var dash_direction: float = 1.0
var dash_timer: float = 0.0

func enter() -> void:
	print("side")
	arm_animation_player = get_parent().get("anim_knuckleblaster") if get_parent() else null
	dash_timer = dash_duration
	var movement = Input.get_axis("move_left", "move_right") 
	if movement != 0: 
		dash_direction = sign(movement)
		parent.facing_direction = dash_direction 
	else:
		dash_direction = parent.facing_direction
		
	if parent.movement_state_machine:
		parent.movement_state_machine.set_process(false)
		parent.movement_state_machine.set_physics_process(false)

	if arm_animation_player:
		arm_animation_player.play("kuck_side")

func process_physics(delta: float) -> State:
	dash_timer -= delta
	
	if dash_timer > 0:
		if parent.flip_container:
			parent.flip_container.scale.x = dash_direction
		parent.velocity.x = dash_direction * dash_speed
		parent.velocity.y = 0 
		parent.move_and_slide() 
		return null
	parent.velocity.x = 0
	parent.move_and_slide()
	return get_parent() as State 

func exit() -> void:
	if arm_animation_player:
		arm_animation_player.play("RESET")
		
	if parent.flip_container:
		parent.flip_container.scale.x = parent.facing_direction
	if parent.movement_state_machine:
		parent.movement_state_machine.set_process(true)
		parent.movement_state_machine.set_physics_process(true)
		if parent.movement_state_machine.has_method("change_state") and parent.movement_state_machine.get("starting_state"):
			parent.movement_state_machine.change_state(parent.movement_state_machine.starting_state)
