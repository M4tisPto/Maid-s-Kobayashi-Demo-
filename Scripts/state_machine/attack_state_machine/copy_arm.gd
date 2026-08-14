extends State

@export var base_state: State
@export var knuckleblaster_state: State

var timer := 0.0
var next_state: State = null


func enter() -> void:
	timer = 0.5
	next_state = null

	print("copy state entered")

	parent.collision_copy.set_deferred("disabled", false)


func exit() -> void:
	parent.collision_copy.set_deferred("disabled", true)


func process_physics(delta: float) -> State:
	timer -= delta

	if next_state:
		return next_state
	if timer <= 0:
		return base_state

	return null


func _on_copy_area_area_entered(area: Area2D) -> void:
	if area.name == "CopyArea":
		next_state = knuckleblaster_state
