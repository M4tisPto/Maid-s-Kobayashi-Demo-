# grab state

extends State

@export var idle_state: State
@export var grabbed_state: State
func enter() -> void:
	print("grabbin'")
	parent.animation_player.play("grab")


func process_physics(_delta: float) -> State:
	if parent.enemy_grabbed:
		return grabbed_state
		parent.animation_player.stop()
	if not parent.animation_player.is_playing():
		return idle_state
	return null
