extends State
@onready var internal_attack_machine: Node = $"../../attack_state_machine"
@export var copy_state: State


func enter() -> void: 
	if parent and parent.gui_arm_text:
		parent.gui_arm_text.text = "current arm: " + self.name
	parent.collision_kuckleblaster.visible = false
	parent.collision_shockwave.visible = false
	parent.collision_copy.visible = false

	if internal_attack_machine and internal_attack_machine.has_method("init"):
		internal_attack_machine.init(parent)
	elif internal_attack_machine:
		internal_attack_machine.parent = parent


func process_input(event: InputEvent) -> State:
	var is_moving_vertical = Input.is_action_pressed("up") or Input.is_action_pressed("duck_down") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
	var is_on_air = parent.velocity == Vector2.ZERO or parent.is_on_floor()
	if internal_attack_machine and internal_attack_machine.has_method("process_input"):
		var new_attack_state = internal_attack_machine.process_input(event)
		if new_attack_state != null:
			return null

	if Input.is_action_just_pressed("attack") and is_on_air and not is_moving_vertical:
		
		return copy_state
			
	return null
