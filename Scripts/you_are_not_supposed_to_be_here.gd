extends Control

@onready var warn_text: Label = $warn_text
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	warn_text.modulate.a = 0.0
	await get_tree().create_timer(1.5).timeout
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(warn_text, "modulate:a", 1.0, 0.7)
	await get_tree().create_timer(2.5).timeout
	audio_stream_player_2d.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/level_selection.tscn")
