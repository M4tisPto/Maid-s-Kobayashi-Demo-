extends State

@export var idle_state: State


func enter() -> void:
	print("entering combo state")
	parent.sophia_animations.play("attack_combo")




func process_physics(delta: float) -> State:
	if not parent.sophia_animations.is_playing():
		return idle_state

	return null
