extends State

@export var test_change: State


func enter() -> void:
	parent.gui_arm_text.text = "current arm: " + self.name

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("test"):
		return test_change
	return null
