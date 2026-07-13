extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func load_scene(target: String) -> void:
	animation_player.play("door_transition")
	await animation_player.animation_finished
	animation_player.play_backwards("door_transition")
	get_tree().change_scene_to_scene(target)


func reload_scene():
	animation_player.play("door_transition")
	await animation_player.animation_finished
	animation_player.play_backwards("door_transition")
	get_tree().reload_current_scene()
	
