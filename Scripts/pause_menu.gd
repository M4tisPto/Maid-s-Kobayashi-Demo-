extends CanvasLayer

@onready var settings_menu: Control = $settings_menu
@onready var margin_container: MarginContainer = $MarginContainer
@onready var label_2: Label = $MarginContainer/VBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else: 
			visible = true
			get_tree().paused = true

func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	


func _on_restart_button_pressed() -> void:
	label_2.text = "Sorry! placeholder."


func _on_options_button_pressed() -> void:
	margin_container.visible =false
	settings_menu.visible = true

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_back_button_pressed() -> void:
	margin_container.visible = true
	settings_menu.visible = false
