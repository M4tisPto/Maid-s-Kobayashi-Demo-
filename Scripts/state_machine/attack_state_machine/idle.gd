extends State
# idle state (Attack SM)

@export var spín_jump_state: State
@export var shoot_state: State
@export var combo_attack: State

var can_spin: bool = true
func enter() -> void:
	parent.collision_combo_1.visible = false
	parent.collision_spin_hitbox.visible = false

func _process(delta: float):
	if parent.velocity == Vector2.ZERO:
		parent.idle_time += delta
	else:
		parent.idle_time = 0.0
		parent.screensaver.visible = false
	
	if parent.idle_time >= parent.idle_limit:
		parent.screensaver.visible = true
	if parent.is_on_floor():
		can_spin = true

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("attack") and Input.is_action_pressed("up") and can_spin:
		can_spin = false
		parent.spin_jump_requested = true 
		
		return spín_jump_state
	
	if Input.is_action_just_pressed("attack") and (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")):
		# now for some reason, it does ALL combo states in one go instead of doing it one by one hitting the attack button
		# this didn't happened a week ago
		return combo_attack
	
	if Input.is_action_just_pressed("attack") and Input.is_action_pressed("duck_down") and parent.velocity == Vector2.ZERO:
		
		return shoot_state

	return null
