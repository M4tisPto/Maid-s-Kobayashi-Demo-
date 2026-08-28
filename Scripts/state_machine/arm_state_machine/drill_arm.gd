extends State 
# How are you, drill arm?
#...
#...
#...




#I'M DEAD!

@onready var neutral: State = $neutral
@onready var up: State = $up
@onready var down: State = $down
@onready var side: State = $side

@onready var internal_attack_machine: Node = $"../../attack_state_machine"
@onready var anim_shockwave: AnimationPlayer = $"../../Flip_container/kuckleblaster/shockwave/AnimationPlayer"
@onready var anim_knuckleblaster: AnimationPlayer = $"../../Flip_container/kuckleblaster/AnimationPlayer"

@export var test_state: State

var current_sub_state: State
var total_time: float = 0.5
var shockwave_charge: float = 0.0
var shockwave_charging: bool = false
var wave_boost: int = 1

func enter() -> void:
	print("This drill will pierce the heavens!")
	if parent and parent.has_method("gui_arm_text"):
		parent.gui_arm_text.text = "current arm: " + self.name
	
	# Desactivar máquina de ataque principal de forma segura
	if parent and parent.attack_state_machine:
		if parent.attack_state_machine.current_state:
			parent.attack_state_machine.current_state.exit()
		parent.attack_state_machine.current_state = null
		parent.attack_state_machine.set_process(false)
		parent.attack_state_machine.set_physics_process(false)
	
	for child in get_children():
		if child is State:
			child.parent = self.parent
			
	if internal_attack_machine and internal_attack_machine.has_method("init"):
		internal_attack_machine.init(parent)

func exit() -> void:
	_reset_charge()
	if current_sub_state:
		current_sub_state.exit()
		current_sub_state = null

	if internal_attack_machine and internal_attack_machine.current_state:
		internal_attack_machine.current_state.exit()
		internal_attack_machine.current_state = null
		
	# Reactivar máquina de ataque principal
	if parent and parent.attack_state_machine:
		parent.attack_state_machine.set_process(true)
		parent.attack_state_machine.set_physics_process(true)
		if parent.attack_state_machine.starting_state:
			parent.attack_state_machine.change_state(parent.attack_state_machine.starting_state)

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("test"):
		return test_state
		
	if current_sub_state:
		var new_sub = current_sub_state.process_input(event)
		if new_sub:
			change_sub_state(new_sub)
	return null

func process_physics(delta: float) -> State:
	# Reseteo de Wave Boost al tocar el suelo
	if parent.is_on_floor() and current_sub_state != down:
		wave_boost = 1

	# Si ya hay un sub-estado activo, él maneja las físicas
	if current_sub_state:
		var new_sub = current_sub_state.process_physics(delta)
		if new_sub == self:
			current_sub_state.exit()
			current_sub_state = null
		elif new_sub:
			change_sub_state(new_sub)
		return null

	# --- LÓGICA DE ATAQUE / CARGA (Solo si no hay sub-estado activo) ---
	if Input.is_action_just_pressed("attack"):
		shockwave_charging = true
		shockwave_charge = 0.0
		
	if shockwave_charging and Input.is_action_pressed("attack"):
		shockwave_charge += delta
		if shockwave_charge >= total_time:
			anim_shockwave.play("shockwave_anim")
			_reset_charge()
			return null # Evita activar otros ataques si ya se cargó
			
	if Input.is_action_just_released("attack"):
		# Si soltó el botón antes del tiempo de carga, ejecuta el ataque direccional corresponditente
		if shockwave_charging: 
			_evaluate_directional_attack()
			_reset_charge()

	return null

func _evaluate_directional_attack() -> void:
	if Input.is_action_pressed("up"):
		change_sub_state(up)
	elif Input.is_action_pressed("duck_down") and wave_boost > 0:
		change_sub_state(down)
		wave_boost -= 1
	elif (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")) and parent.is_on_floor():
		change_sub_state(side)
	else:
		change_sub_state(neutral)

func _reset_charge() -> void:
	shockwave_charging = false
	shockwave_charge = 0.0

func change_sub_state(new_sub: State) -> void:
	if not new_sub:
		return
	if current_sub_state == new_sub:
		current_sub_state.exit()
		current_sub_state.enter()
		return
	if current_sub_state:
		current_sub_state.exit()
		
	current_sub_state = new_sub
	current_sub_state.enter()
