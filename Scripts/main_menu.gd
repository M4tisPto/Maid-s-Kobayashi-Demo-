extends Control

var level: int = 1
@onready var start_button: Button = $MarginContainer/VBoxContainer2/Start_Button as Button
@onready var exit_button: Button = $MarginContainer/VBoxContainer2/Exit_Button as Button
@onready var start_level = preload("res://Scenes/Levels/test_level.tscn") as PackedScene
@onready var options_button: Button = $MarginContainer/VBoxContainer2/Options_Button
@onready var margin_container: MarginContainer = $MarginContainer as MarginContainer
@onready var settings_menu: Control = $settings_menu

func _ready() -> void:
	AudioController.play_music("menu_music", -10)
	handle_connection_signals()

func on_start_pressed() -> void:
	SceneTransition.load_scene("res://Scenes/Levels/test_level.tscn")
	var tween = create_tween()
	tween.tween_property(AudioController.current_music, "volume_db", -50, 0.8)
	await tween.finished
	AudioController.stop_music()


func on_options_pressed() -> void:
	SceneTransition.normal_transition()
	await get_tree().create_timer(0.8).timeout
	
	margin_container.visible =false
	settings_menu.visible = true
 
func on_exit_pressed() -> void:
	print("C PAPU MISTERIOSO CERRO EL JUEGO")
	get_tree().quit()

func on_exit_options_menu() -> void:
	margin_container.visible = true

func handle_connection_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)





func _on_back_button_pressed() -> void:
	SceneTransition.normal_transition()
	await get_tree().create_timer(0.8).timeout
	margin_container.visible =true
	settings_menu.visible = false
