extends State
@export var base_state: State
@export var knuckleblaster_state: State
var timer = 0
func enter() -> void:
	timer = 0.1
	print("copy state entered")
	
	parent.collision_copy.set_deferred("disabled", false)

func process_physics(delta: float) -> State:
	timer -= delta
	if parent.copy_area.get_overlapping_areas().is_empty():
		parent.collision_copy.set_deferred("disabled", true)
		return base_state
	return null

func _on_copy_area_area_entered(area: Area2D):

	print("Collision detected with: ", area.name)
	if area.name == "Hurtbox":
		return knuckleblaster_state
		
