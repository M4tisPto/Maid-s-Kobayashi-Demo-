extends State

@export var idle_state: State

var animation_finished := false


func enter() -> void:
	print("entering combo state")

	animation_finished = false

	parent.movement_locked = true
	parent.velocity = Vector2.ZERO

	parent.collision_combo.visible = true
	parent.animation_player.play("combo")


func exit() -> void:
	parent.movement_locked = false
	parent.velocity = Vector2.ZERO
	parent.collision_combo.visible = false


func process_frame(delta: float) -> State:
	if animation_finished:
		var movement = Input.get_axis("move_left", "move_right") * move_speed
		if movement:
			parent.sophia_animations.play("run_loop")
		return idle_state

	return null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "combo":
		animation_finished = true
