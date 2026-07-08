extends State

@export
var idle_state: State

const HURT_DURATION: float = 0.15
var timer: float = 0.0
var current_gravity = gravity


func enter() -> void:
	timer = HURT_DURATION
	
	parent.invisible = true
	parent.hurtbox.set_deferred("monitoring", false)

	print("hurt state, yeouch!")

func process_physics(delta: float) -> State:
	timer -= delta
	if parent.velocity.y < 0:
		current_gravity *= parent.fall_gravity_multiplier
	parent.velocity.y += gravity * delta
	
	parent.velocity = parent.knockback_velocity
	parent.move_and_slide()
	
	
	
	if timer <= 0:
		return idle_state
	return null


func exit() -> void:
	parent.start_invulnerability_timer()
