extends Control

@export var scroll_speed: float = 200.0

func _ready() -> void:
	AudioController.play_music("credits")

func _process(delta: float) -> void:
	$VBoxContainer.position.y -= scroll_speed * delta
	if Input.is_action_pressed("accept"):
		$VBoxContainer.position.y -= (scroll_speed * 2) * delta
	
	if Input.is_action_just_pressed("ui_cancel"):
		finish_credits()

func finish_credits() -> void:
	SceneTransition.load_scene("res://Scenes/main_menu.tscn")
