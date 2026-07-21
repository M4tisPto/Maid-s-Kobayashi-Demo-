extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$ColorRect.visible = false
	$ColorRect.scale.x = 0
func load_scene(target: String) -> void:
	$ColorRect.visible = true
	animation_player.play("door_transition")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target)
	animation_player.play_backwards("door_transition")
	get_tree().paused = false
	await animation_player.animation_finished
	$ColorRect.visible = false

func reload_scene() -> void:
	$ColorRect.visible = true
	
	animation_player.play("door_transition")
	await animation_player.animation_finished
	
	get_tree().reload_current_scene()
	
	animation_player.play_backwards("door_transition")
	await animation_player.animation_finished
	$ColorRect.visible = false
