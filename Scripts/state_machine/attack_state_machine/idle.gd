extends State

@export var grab_state: State
@export var spín_jump_state: State
@export var shoot_state: State
var can_spin: bool = true

func _process(delta: float):
	if parent.is_on_floor():
		can_spin = true


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("attack") and Input.is_action_pressed("up") and not parent.is_on_floor() and can_spin:
		can_spin = false
		parent.velocity.y = 0.0
		return spín_jump_state
#	if Input.is_action_just_pressed("grab"): pa luego
#		return grab_state
	if Input.is_action_just_pressed("attack") and Input.is_action_pressed("duck_down") and parent.is_on_floor():
		return shoot_state
	return null
