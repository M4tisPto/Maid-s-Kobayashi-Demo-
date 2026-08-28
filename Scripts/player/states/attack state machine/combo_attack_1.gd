extends State

@export var idle_state: State
@export var attack_combo_2: State
var animation_finished := false
var dash_speed = 15
var can_combo := false # <--- NUEVA: Controla cuándo se permite el siguiente golpe

func enter() -> void:
	print("entering combo state")
	animation_finished = false
	can_combo = false # <--- Resetear al entrar
	parent.movement_locked = true

	if GameManager.is_collisions_checked:
		parent.collision_combo_1.visible = true
		parent.collision_combo_1.set_deferred("disabled", false)
	else:
		parent.collision_combo_1.visible = false
		parent.collision_combo_1.set_deferred("disabled", true)

	parent.sophia_animations.play("attack_combo_1")

func exit() -> void:
	parent.movement_locked = false
	parent.velocity = Vector2.ZERO
	parent.collision_combo_1.visible = false
	parent.collision_combo_1.set_deferred("disabled", true)

func process_frame(delta: float) -> State:
	# OPCIÓN B por código: Si no usas la animación, puedes activar el combo 
	# cuando la animación vaya a más de la mitad (ej. 60% de progreso)
	if parent.sophia_animations.is_playing() and parent.sophia_animations.get_frame_progress() > 0.5:
		can_combo = true

	if animation_finished:
		return idle_state
	return null

func process_input(event: InputEvent) -> State:
	# CORRECCIÓN: Ahora requiere "just_pressed" Y que la ventana de combo esté abierta
	if Input.is_action_just_pressed("attack") and can_combo:
		return attack_combo_2
	return null

func process_physics(delta: float) -> State:
	var movement = Input.get_axis("move_left", "move_right")
	parent.velocity.x = movement * dash_speed
	parent.move_and_slide()
	return null

func _on_animated_sprite_2d_2_animation_finished() -> void:
	animation_finished = true
