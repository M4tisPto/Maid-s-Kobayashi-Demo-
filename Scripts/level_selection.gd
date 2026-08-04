extends Node2D
@onready var control: Control = $CarouselContainer/Control

var levels = []
@onready var level_name: RichTextLabel = $LevelName

func _ready() -> void:
	levels.append($CarouselContainer.selected_index)
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
				SceneTransition.load_scene("res://Scenes/Levels/player_level_testing_room.tscn")
			1:
				print("second leval")
			2:
				print("third leval")
			_:
				print("no level encountered")


func update_label():
	var detect_index = $CarouselContainer.position_offset_node.get_child($CarouselContainer.selected_index).name
	level_name.text = str(detect_index)
