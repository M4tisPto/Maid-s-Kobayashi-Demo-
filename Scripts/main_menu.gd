extends Control

var level: int = 1
@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level = preload("res://Scenes/Levels/test_level.tscn") as PackedScene
@onready var options_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button
@onready var margin_container: MarginContainer = $MarginContainer as MarginContainer

func _ready() -> void:
	AudioController.play_music("menu_music", -10)
	handle_connection_signals()

func on_start_pressed() -> void:
	AudioController.stop_music()

	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	margin_container.visible =false
 
func on_exit_pressed() -> void:
	print("C PAPU MISTERIOSO CERRO EL JUEGO")
	get_tree().quit()

func on_exit_options_menu() -> void:
	margin_container.visible = true

func handle_connection_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
