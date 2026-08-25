extends State
# movement move

@export var fall_state: State
@export var idle_state: State
@export var jump_state: State

var acceleration: float = 50.5
var friction: float = 4.5

func enter() -> void:
	parent.sophia_animations.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	parent.sophia_animations.play("run_start")

func exit() -> void:
	if parent.sophia_animations.animation_finished.is_connected(_on_animation_finished):
		parent.sophia_animations.animation_finished.disconnect(_on_animation_finished)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	return null

func _on_animation_finished() -> void:
	if parent.sophia_animations.animation == "run_start":
		parent.sophia_animations.play("run_loop")

func process_physics(delta: float) -> State:

	if parent.spin_jump_requested:
		return jump_state

	parent.velocity.y += gravity * delta
	var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var velocity_weight: float = delta * (acceleration if x_input else  friction)
	if x_input != 0:
		parent.sophia_animations.flip_h = x_input < 0
		parent.facing_direction = sign(x_input)
	parent.velocity.x = lerp(parent.velocity.x, x_input * move_speed, velocity_weight)
	parent.move_and_slide()
	print(parent.velocity.x)
	if not parent.is_on_floor():
		return fall_state
		
	if parent.velocity.x == 0:
		return idle_state
	return null
