extends Node2D
@onready var control: Control = $CarouselContainer/Control




var levels = []
@onready var level_name: RichTextLabel = $LevelName

func _ready() -> void:
	levels.append($CarouselContainer.selected_index)
	AudioController.play_music("level_selector")
	update_label()




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		$CarouselContainer._left()
		update_label()
	elif event.is_action_pressed("move_right"):
		$CarouselContainer._right()
		update_label()
	
	if event.is_action_pressed("accept") : # espacio
		var current_index = $CarouselContainer.selected_index
		match current_index:
			0:
				SceneTransition.load_scene("res://Scenes/Levels/1.tscn")
				GameManager.reset_player_data()
				var tween = create_tween()
				tween.tween_property(AudioController.current_music, "volume_db", -80, 0.8)
				GameManager.set_current_level(1)
				await tween.finished
				AudioController.stop_music()
			1:
				SceneTransition.load_scene("res://Scenes/Levels/2.tscn")
				var tween = create_tween()
				tween.tween_property(AudioController.current_music, "volume_db", -80, 0.8)
				GameManager.set_current_level(2)
				await tween.finished
				AudioController.stop_music()
			2:
				
				get_tree().change_scene_to_file("res://Scenes/you_are_not_supposed_to_be_here.tscn")
				AudioController.stop_music()
			_:
				print("no level encountered")
	if event.is_action_pressed("pause"):
		SceneTransition.load_scene("res://Scenes/main_menu.tscn")
		AudioController.stop_music()

func update_label():
	var detect_index = $CarouselContainer.position_offset_node.get_child($CarouselContainer.selected_index).name
	level_name.text = str(detect_index)
