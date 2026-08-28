extends State

var arm_animation_player: AnimationPlayer

# Nombres de las animaciones de Sophia
const anim_start_name := "knuckle_side_start"
const anim_dash_name := "knuckle_side_dash"
const anim_hit_name := "knuckle_side_hit" # Ajustar si el nombre real varía

# Ajustes de comportamiento (Estilo Falcon Side-B)
var charge_duration := 0.25    # Duración de la carga inicial (Frenado)
var dash_speed := 550.0       # Velocidad explosiva del avance
var dash_duration := 0.25     # Tiempo máximo que dura el avance si no toca nada
var hit_duration := 0.3       # Cuánto dura la pausa/animación del impacto al golpear
var recovery_duration := 0.15 # Penalización de tiempo si el dash falla y no golpea

# Máquina de estados interna para las fases del ataque
enum Phase { CHARGE, DASH, HIT, RECOVERY }
var current_phase: Phase = Phase.CHARGE
var phase_timer: float = 0.0
var dash_direction: float = 1.0

func enter() -> void:
	print("¡Falcon Knuckle!")
	arm_animation_player = get_parent().get("anim_knuckleblaster") if get_parent() else null
	
	# 1. Determinar dirección del ataque basado en el input actual
	var movement = Input.get_axis("move_left", "move_right") 
	if movement != 0: 
		dash_direction = sign(movement)
		parent.facing_direction = dash_direction 
	else:
		dash_direction = parent.facing_direction
	
	# Orientar contenedores visuales
	if parent.flip_container:
		parent.flip_container.scale.x = dash_direction

	# 2. Apagar control estándar de físicas del jugador para tomar control absoluto
	if parent.movement_state_machine:
		parent.movement_state_machine.set_process(false)
		parent.movement_state_machine.set_physics_process(false)

	# 3. Fase Inicial: Carga / Anticipación
	current_phase = Phase.CHARGE
	phase_timer = charge_duration
	
	if parent.has_method("sophia_animations_play"):
		parent.sophia_animations_play(anim_start_name)
	elif parent.get("sophia_animations"):
		parent.sophia_animations.play(anim_start_name)

func process_physics(delta: float) -> State:
	phase_timer -= delta

	match current_phase:
		Phase.CHARGE:
			# El personaje se frena en seco acumulando energía
			parent.velocity.x = 0
			parent.move_and_slide()
			
			if phase_timer <= 0:
				# Transicionar al Dash
				current_phase = Phase.DASH
				phase_timer = dash_duration
				
				# Reproducir animaciones de avance
				if parent.has_method("sophia_animations_play"):
					parent.sophia_animations_play(anim_dash_name)
				elif parent.get("sophia_animations"):
					parent.sophia_animations.play(anim_dash_name)
					
				if arm_animation_player:
					arm_animation_player.play("kuck_side")
		
		Phase.DASH:
			# Desplazamiento horizontal de alta velocidad
			parent.velocity.x = dash_direction * dash_speed
			parent.velocity.y = 0 
			parent.move_and_slide()
			
			# Condición crítica: Detenerse inmediatamente al detectar colisión enemiga
			if check_enemy_collision():
				current_phase = Phase.HIT
				phase_timer = hit_duration
				
				# Reproducir animación del golpe definitivo
				if parent.has_method("sophia_animations_play"):
					parent.sophia_animations_play(anim_hit_name)
				elif parent.get("sophia_animations"):
					parent.sophia_animations.play(anim_hit_name)
				return null
				
			if phase_timer <= 0:
				# El dash terminó en el aire o suelo sin encontrar objetivos (Fallo)
				current_phase = Phase.RECOVERY
				phase_timer = recovery_duration

		Phase.HIT:
			# Impacto conectado: Frenar en el sitio mientras la animación del golpe corre
			parent.velocity.x = 0
			parent.move_and_slide()
			
			if phase_timer <= 0:
				return get_parent() as State # Volver al estado base del brazo

		Phase.RECOVERY:
			# Recuperación tras fallar: Desaceleración suave para evitar cortes bruscos
			parent.velocity.x = move_toward(parent.velocity.x, 0, dash_speed * delta * 4)
			parent.move_and_slide()
			
			if phase_timer <= 0:
				return get_parent() as State # Volver al estado base del brazo

	return null

func exit() -> void:
	# Limpieza de animaciones del arma
	if arm_animation_player:
		arm_animation_player.play("RESET")
		
	if parent.flip_container:
		parent.flip_container.scale.x = parent.facing_direction
		
	# Restaurar por completo el control de movimiento del jugador
	if parent.movement_state_machine:
		parent.movement_state_machine.set_process(true)
		parent.movement_state_machine.set_physics_process(true)
		if parent.movement_state_machine.has_method("change_state") and parent.movement_state_machine.get("starting_state"):
			parent.movement_state_machine.change_state(parent.movement_state_machine.starting_state)

# Analizador de impactos frente a entidades hostiles
func check_enemy_collision() -> bool:
	# Evalúa si la física del cuerpo chocó directamente con un enemigo en este frame
	for i in parent.get_slide_collision_count():
		var collision = parent.get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("enemies"): 
			return true
	return false
