extends State
# spin jump state (Attack SM)
@export var idle_state: State

func enter():
	print("le spin")
	parent.sophia_animations.play("jump")
	parent.animation_player.play("spin_attack")

func process_physics(delta: float) -> State:
	if parent.is_on_floor() and parent.velocity.y >= 0:
		return idle_state

	return null
