extends State

@export var idle_state: State
@export var attack_combo_2: State
var animation_finished := false
var dash_speed = 50

func enter() -> void:
	print("entering combo state")

	animation_finished = false

	parent.movement_locked = true
	if GameManager.is_collisions_checked:
		parent.collision_combo.visible = true
	parent.sophia_animations.play("attack_combo_1")


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

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("attack"):
		return attack_combo_2
	return null

func process_physics(delta: float) -> State:
	var movement = Input.get_axis("move_left", "move_right")
	parent.velocity.x = movement * dash_speed
	print(parent.velocity.x)
	parent.move_and_slide()
	return null

func _on_animated_sprite_2d_2_animation_finished() -> void:
	animation_finished = true
