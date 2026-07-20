extends State
@export var test_change: State

@onready var internal_attack_machine: Node = $"../../attack_state_machine"


func enter() -> void: 
	if parent and parent.gui_arm_text:
		parent.gui_arm_text.text = "current arm: " + self.name
	parent.collision_kuckleblaster.visible = false
	parent.collision_spin_hitbox.visible = true

	if internal_attack_machine and internal_attack_machine.has_method("init"):
		internal_attack_machine.init(parent)
	elif internal_attack_machine:
		internal_attack_machine.parent = parent

func exit() -> void:

	pass

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("test"):
		if test_change:
			return test_change
		else:
			return null
			
	if internal_attack_machine and internal_attack_machine.has_method("process_input"):
		internal_attack_machine.process_input(event)
		
	return null

func process_physics(delta: float) -> State:
	if internal_attack_machine and internal_attack_machine.has_method("process_physics"):
		internal_attack_machine.process_physics(delta)
	return null

func process_frame(delta: float) -> State:
	if internal_attack_machine and internal_attack_machine.has_method("process_frame"):
		internal_attack_machine.process_frame(delta)
	return null
