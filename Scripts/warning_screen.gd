extends Control
@onready var start_sfx: AudioStreamPlayer2D = $Start_sfx


# es el codigo mas simple xd
func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	start_sfx.play()


func _process(delta: float) -> void:
	await get_tree().create_timer(2.5).timeout
	if Input.is_action_just_pressed("accept"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
