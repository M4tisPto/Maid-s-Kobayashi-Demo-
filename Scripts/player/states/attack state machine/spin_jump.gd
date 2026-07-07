# spin jump (en attack_state_machine)
extends State
var timer := 0.0
@export var idle_state: State
@export var fall_state: State
@export
var spin_impulse:float = 400.0


func enter():
	print("le spin")
	timer = 0.25
	parent.velocity.y = -spin_impulse

func process_physics(delta: float) -> State:
	if parent.is_on_floor():
		return idle_state
	timer -= delta
	if timer <= 0:
		return fall_state
		# por algun motivo la gravedad es mas rapida y tambien el movimiento del personaje...
	return null
