extends Node2D
var skip_times = 2
@onready var skip_warning: Label = $"skip warning"

func _ready() -> void:
	await $VideoStreamPlayer.finished
	get_tree().change_scene_to_file("res://Scenes/warning_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("accept"):
		skip_times -= 1
		skip_warning.visible = true
		if skip_times <= 0:
			get_tree().change_scene_to_file("res://Scenes/warning_screen.tscn")
