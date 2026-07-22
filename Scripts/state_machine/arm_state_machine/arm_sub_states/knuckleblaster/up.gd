extends State
var arm_animation_player: AnimationPlayer


func enter() -> void:
	print("up")
	arm_animation_player = get_parent().get("anim_knuckleblaster") if get_parent() else null
	arm_animation_player.play("knuckle_up")


func process_physics(_delta: float) -> State:
	if not arm_animation_player.is_playing():
		arm_animation_player.play("RESET")
		return get_parent() as State
	return null
