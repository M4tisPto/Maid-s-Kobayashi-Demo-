extends State
# knuckle blaster arm (inside an arm state machine)
@onready var neutral: State = $neutral
@onready var up: State = $up
@onready var down: State = $down
@onready var side: State = $side
@onready var internal_attack_machine: Node = $"../../attack_state_machine"
@onready var anim_shockwave: AnimationPlayer = $"../../Flip_container/kuckleblaster/shockwave/AnimationPlayer"
@onready var anim_knuckleblaster: AnimationPlayer = $"../../Flip_container/kuckleblaster/AnimationPlayer"

@export var test_state: State

var new_arm: State
var current_sub_state: State
var total_time: float = 0.5
var shockwave_charge: float = 0.0
var shockwave_charging = false
var side_dash = false
var can_dash = true
var wave_boost = 1

func enter() -> void:
	print("KA-BOOOM!!")
	parent.gui_arm_text.text = "current arm: " + self.name
	
	if parent and parent.attack_state_machine:
		if parent.attack_state_machine.current_state:
			parent.attack_state_machine.current_state.exit()
		parent.attack_state_machine.current_state = null
		parent.attack_state_machine.set_process(false)
		parent.attack_state_machine.set_physics_process(false)
		
	parent.collision_kuckleblaster.visible = true
	parent.collision_shockwave.visible = true
	parent.collision_spin_hitbox.visible = false
	parent.collision_copy.visible = false
	
	for child in get_children():
		if child is State:
			child.parent = self.parent
			
	if internal_attack_machine and internal_attack_machine.has_method("init"):
		internal_attack_machine.init(parent)


func exit() -> void:
	if internal_attack_machine and internal_attack_machine.current_state:
		internal_attack_machine.current_state.exit()
		internal_attack_machine.current_state = null
		
	if parent and parent.attack_state_machine:
		parent.attack_state_machine.set_process(true)
		parent.attack_state_machine.set_physics_process(true)
		if parent.attack_state_machine.starting_state:
			parent.attack_state_machine.change_state(parent.attack_state_machine.starting_state)


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("test"):
		return test_state
		
	if current_sub_state:
		var new_sub = current_sub_state.process_input(event)
		if new_sub:
			change_sub_state(new_sub)
			
	return null


func process_physics(delta: float) -> State:
	# 1. Si hay un sub-estado activo (como side, up, down), delegamos las físicas por completo
	if current_sub_state:
		var new_sub = current_sub_state.process_physics(delta)
		if new_sub == self:
			current_sub_state.exit()
			current_sub_state = null
		elif new_sub:
			change_sub_state(new_sub)
		return null

	# 2. Gestión de la carga de la Onda de Choque (Solo si estamos en estado neutro/libre)
	if Input.is_action_just_pressed("attack"):
		shockwave_charging = true
		shockwave_charge = 0.0
	
	if shockwave_charging and Input.is_action_pressed("attack"):
		shockwave_charge += delta
		
	if shockwave_charge >= total_time and shockwave_charging:
		anim_shockwave.play("shockwave_anim")
		shockwave_charging = false
	
	if Input.is_action_just_released("attack"):
		shockwave_charging = false
		shockwave_charge = 0.0

	# 3. Transiciones a Sub-Estados de Ataque (Evaluación de Inputs)
	if Input.is_action_pressed("up") and Input.is_action_just_pressed("attack"):
		shockwave_charging = false
		change_sub_state(up)
		
	elif Input.is_action_pressed("duck_down") and Input.is_action_just_pressed("attack") and wave_boost > 0:
		shockwave_charging = false
		change_sub_state(down)
		wave_boost -= 1
		
	elif (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")) and Input.is_action_just_pressed("attack"):
		if parent.is_on_floor():
			shockwave_charging = false # Cancelamos la carga de la onda
			change_sub_state(side)     # Side.gd manejará sus propias animaciones y tiempos
			return null
			
	elif Input.is_action_just_pressed("attack"):
		change_sub_state(neutral)
		
	# Recuperación del boost de caída libre
	if parent.is_on_floor() and current_sub_state != down:
		wave_boost = 1
		
	return null


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
