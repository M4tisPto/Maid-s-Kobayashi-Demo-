extends State

@export var idle_state: State

func enter() -> void:
	print("ducked down")
	parent.animation_player.play("ducked")


func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_released("duck_down"):
		parent.animation_player.play("RESET")
		return idle_state
	return null
