extends State

var new_arm: State



@onready var animation_player: AnimationPlayer = $"../../shockwave/AnimationPlayer"




func enter() -> void:
	print("KA-BOOOM!!")
	parent.collision_kuckleblaster.visible = true
	parent.gui_arm_text.text = "current arm: " + self.name



func _input(event: InputEvent) -> void:
	# how to check if i'm on this spececific state
	if Input.is_action_just_pressed("attack") and parent.arm_state_machine.current_state == self:
		animation_player.play("shockwavea_anim")


#func process_input(_event: InputEvent) -> State:
#	if Input.is_action_just_pressed("grab"):
#		return new_arm
#	return null
