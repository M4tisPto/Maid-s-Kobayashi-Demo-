extends  CanvasLayer

const CLOSED_OFFSET := Vector2(0, 1000)
const SLIDE_TIME := 0.9
const STAGGER := 0.06

@onready var panel_container: PanelContainer = $PanelContainer
@onready var v_box_container: VBoxContainer = $PanelContainer/VBoxContainer
@onready var settings_menu: Control = $settings_menu

var current_level: int = 1

var _buttons: Array[AnimatedButtonPause] = []
var _tween: Tween = null
var _open := false
var is_on_options = false


# silly animation
func _ready() -> void:
	for child in v_box_container.get_children():
		if child is AnimatedButtonPause:
			_buttons.append(child)
			print(_buttons)
	_reset()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle(not _open)


func _toggle(should_open: bool) -> void:
	_open = not _open
	panel_container.visible = should_open
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_parallel()
	
	if should_open:
		panel_container.visible = true
	
	var count := _buttons.size()
	for i in count:
		print(i)
		var step = i if should_open else count -1 - i
		var target := Vector2.ZERO if should_open else CLOSED_OFFSET
		
		_tween.tween_property(_buttons[i], "offset_transform_position", target, SLIDE_TIME).set_delay(step * STAGGER).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(panel_container, "modulate", Color.WHITE if should_open else Color.TRANSPARENT, SLIDE_TIME)
	if !should_open:
		_tween.chain().tween_callback(func () ->void: panel_container.visible = false)
func _reset() -> void:
	visible = false
	panel_container.visible = false
	panel_container.modulate = Color.TRANSPARENT
	_open = false
	for button in _buttons:
		button.offset_transform_position = CLOSED_OFFSET


# the menu in general






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
	GameManager.reset_player_data()
	var level_path := "res://Scenes/Levels/%d.tscn" % current_level
	DoorTransition.load_scene(level_path)


func _on_options_button_pressed() -> void:
	_toggle(false)
	settings_menu.visible = true

func _on_exit_button_pressed() -> void:
	DoorTransition.load_scene("res://Scenes/main_menu.tscn")
	


func _on_back_button_pressed() -> void:
	_toggle(not _open)
	settings_menu.visible = false
