extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func load_scene(target: String) -> void:
	animation_player.play("transition")
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file(target)

func reload_scene() -> void:
	animation_player.play("transition")
	await get_tree().create_timer(0.8).timeout
	get_tree().reload_current_scene()


func normal_transition():
	animation_player.play("transition")
	
