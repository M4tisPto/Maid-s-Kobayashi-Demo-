extends State

@export var idle_state: State


func enter() -> void:
	print("holding grab!")
	parent.collision_grab.set_deferred("disabled", false)
