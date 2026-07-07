extends State

@export var idle_state: State
@export var fall_state: State # Added to handle mid-air animation endings
@export var spin_impulse: float = 400.0

var animation_complete: bool = false

func enter():
	print("le spin")
	animation_complete = false
	parent.spin_attack.play("spin_attack")
	
	# Connect signal dynamically so it only fires for this state instance
	if not parent.spin_attack.is_connected(_on_animation_finished):
		parent.spin_attack.animation_finished.connect(_on_animation_finished)
		
	parent.spin_jump_requested = true

func exit():
	if spin_animation.animation_finished.is_connected(_on_animation_finished):
		spin_animation.animation_finished.disconnect(_on_animation_finished)

func process_physics(delta: float) -> State:
	# If we touch the ground, exit immediately
	if parent.is_on_floor():
		return idle_state
		
	# If animation ends while still in the air, transition to fall/normal state
	if animation_complete:
		return fall_state

	return null

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "spin_attack":
		animation_complete = true
