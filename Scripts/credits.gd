extends Control

@export var scroll_speed: float = 100.0
const MAX_SCROLL_LIMIT: float = -3100.0

func _ready() -> void:
	AudioController.play_music("credits")
	$Label.visible = false

func _process(delta: float) -> void:
	var current_speed := scroll_speed
	
	if Input.is_action_pressed("accept"):
		current_speed *= 3.0
	
	$VBoxContainer.position.y -= current_speed * delta
	
	if $VBoxContainer.position.y <= MAX_SCROLL_LIMIT:
		$VBoxContainer.position.y = MAX_SCROLL_LIMIT
		$Label.visible = true
	
	if Input.is_action_just_pressed("ui_cancel"):
		finish_credits()

func finish_credits() -> void:
	SceneTransition.load_scene("res://Scenes/main_menu.tscn")
