extends State
# copy arms
@export var base_state: State
@export var knuckleblaster_state: State

var timer := 0.0
var next_state: State = null


func enter() -> void:
	next_state = null
	timer = 1
	parent.sophia_animations.process_mode = Node.PROCESS_MODE_ALWAYS
	print("copy state entered")
	parent.movement_locked = true
	parent.sophia_animations.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	parent.sophia_animations.play("copy_start")
	

func exit() -> void:
	if parent.sophia_animations.animation_finished.is_connected(_on_animation_finished):
		parent.sophia_animations.animation_finished.disconnect(_on_animation_finished)
	parent.collision_copy.visible = false
	parent.sophia_animations.play_backwards("copy_start")
	parent.collision_copy.set_deferred("disabled", true)
	parent.movement_locked = false
func _on_animation_finished():
	
	parent.sophia_animations.play("copy_loop", )
	parent.collision_copy.visible = true
	parent.collision_copy.set_deferred("disabled", false)

func process_physics(delta: float) -> State:
	timer -= delta
	print(timer)
	if next_state:
		return next_state
	if timer <= 0:
		return base_state
	return null


func _on_copy_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("knuckle_enemy"):
		parent.is_copying = true
		HitstopManager.new_arm_stop()
		next_state = knuckleblaster_state
		parent.is_copying = false
