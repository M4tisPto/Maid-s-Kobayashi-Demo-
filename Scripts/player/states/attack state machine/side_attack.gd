extends State

@export var idle_state: State

var timer := 0.0

func enter() -> void:
	# activa la hitbox que esta dentro del juador
	AudioController.play_sound("punch")
	parent.collision_hitbox.set_deferred("disabled", false)
	timer = 0.1
	print("punch state!")



func process_physics(delta: float) -> State:
	# da un tiempo procesado (0.1 segundos)
	timer -= delta
	if timer <= 0:
		# si el contador es menor o igual a 0, se desactiva la hitbox y retorna al estado idle del attack state machine
		parent.collision_hitbox.set_deferred("disabled", true)
		return idle_state
	return null
