extends State

@export var base: State
func enter() -> void:
	print("test")




func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("test"):
		return base
	return null
