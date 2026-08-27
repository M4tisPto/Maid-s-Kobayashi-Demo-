extends State

@export var run_state: State
@export var idle_state: State
@export var fall_state: State

@export var skid_frames: float = 10.0
@export var skid_deceleration: float = 3000.0
@export var skid_acceleration: float = 2500.0
@export var skid_boost: float = 50.0

var skid_timer: float = 0.0
var new_direction: int = 0


func enter() -> void:
	parent.sophia_animations.play("skid")
	new_direction = parent.skid_direction

	skid_timer = skid_frames / 60.0
func process_physics(delta: float) -> State:

	parent.velocity.y += gravity * delta

	skid_timer -= delta



	parent.facing_direction = new_direction
	parent.sophia_animations.flip_h = new_direction < 0



	parent.velocity.x = move_toward(
		parent.velocity.x,
		0.0,
		skid_deceleration * delta
	)

	parent.move_and_slide()


	if skid_timer <= 0.0:

		parent.velocity.x = new_direction * (
			move_speed + skid_boost
		)

		return run_state

	if not parent.is_on_floor():
		return fall_state

	return null
