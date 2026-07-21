extends CanvasLayer

@onready var settings_menu: Control = $settings_menu
@onready var margin_container: MarginContainer = $MarginContainer
@onready var label_2: Label = $MarginContainer/VBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if settings_menu.visible:
			_on_back_button_pressed()
		else:
			toggle_pause()
	if Input.is_action_just_pressed("attack"): #cancel
		_on_back_button_pressed()

func toggle_pause() -> void:
	var current_state: bool = !get_tree().paused
	get_tree().paused = current_state
	visible = current_state

func _on_resume_button_pressed() -> void:
	toggle_pause()
	


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	DoorTransition.reload_scene()


func _on_options_button_pressed() -> void:
	margin_container.visible =false
	settings_menu.visible = true

func _on_exit_button_pressed() -> void:
	DoorTransition.load_scene("res://Scenes/main_menu.tscn")
	


func _on_back_button_pressed() -> void:
	margin_container.visible = true
	settings_menu.visible = false
