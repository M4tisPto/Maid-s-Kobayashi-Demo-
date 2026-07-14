# grab state

extends State

@export var idle_state: State
@export var grabbed_state: State
func enter() -> void:
	print("grabbin'")
