extends State
var arm_animation_player: AnimationPlayer

var dash_speed := 250.0
var dash_duration := 0.5
var dash_direction: float = 1.0
var dash_timer: float = 0.0
func enter() -> void:
	print("side")
	arm_animation_player = get_parent().get("anim_knuckleblaster") if get_parent() else null
	dash_timer = dash_duration
	var movement = Input.get_axis("move_left", "move_right") 
	if movement != 0: 
		dash_direction = sign(movement)
	else:
		dash_direction = parent.facing_direction
	arm_animation_player.play("kuck_side")
func process_physics(delta: float) -> State:
	dash_timer -= delta
	
	if dash_timer > 0:
		parent.velocity.x = dash_direction * dash_speed
		parent.velocity.y = 0
		parent.move_and_slide()
		return null
	parent.velocity.x = 0
	return get_parent() as State 

func exit() -> void:
	print("bye bye")
	if arm_animation_player.is_playing():
		arm_animation_player.stop()
