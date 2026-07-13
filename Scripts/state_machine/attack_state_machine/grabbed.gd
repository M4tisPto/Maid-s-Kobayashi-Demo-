extends State

@export var idle_state: State


func enter() -> void:
	print("holding grab!")


func process_physics(_delta: float) -> State:
	while parent.enemy_grabbed:
		parent.collision_grab.set_deferred("disabled", false)
	if not parent.enemy_grabbed:
		return idle_state
	return null
