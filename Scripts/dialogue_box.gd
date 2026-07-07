extends Control

@export_file("*.json") var jsonsrc
@export var char_text: RichTextLabel
@export var char_name: Label
var full_message := ""
var scene_script: Array
var current_line := 0
var still_typing := false
@onready var type_timer: Timer = $Base/BG/Timer
@export var letter_speed := 0.018
@export var comma_pause := 0.12
@export var dot_pause := 0.25
@export var exclamation_pause := 0.15
var talk_sound_map :={
	"Test" : "talk_test",
	"Sophia": "talk_sophia",
	"Matis": "talk_matis",
	"Default": "talk_default"
}
var talk_cooldown := 0.0
var skip_next := false 

func _ready() -> void:
	get_json(jsonsrc)

func _process(delta: float) -> void:
	if talk_cooldown > 0:
		talk_cooldown -= delta

func update_message(message: String) -> void:
	full_message = message
	char_text.text = full_message
	char_text.visible_characters = 0
	still_typing = true
	type_timer.wait_time = letter_speed
	type_timer.start()

func get_json(src: String):
	var jsontext = FileAccess.get_file_as_string(src)
	var jsondict = JSON.parse_string(jsontext)

	if jsondict == null:
		print("Error cargando JSON")
		return

	scene_script = jsondict["DIALOGUE"]
	show_line()

func show_line():
	if current_line >= scene_script.size():
		return

	var block = scene_script[current_line]


	if block[0] == "_skip":
		skip_next = true
		current_line += 1       
		show_line()              
		return                  
	
	if block[0] == "playMusic":
		var track = block[1]
		var volume = block[2]
		
		AudioController.play_music(track, volume)
		current_line += 1
		show_line()
		return
	
	if block[0] == "stopMusic":
		AudioController.stop_music()
		return
	
	
	char_name.text = block[1] if block.size() > 1 else ""
	update_message(block[0])

	if skip_next:
		skip_next = false
		while still_typing:
			await get_tree().process_frame
		current_line += 1
		show_line()

func interrupt_dialogue():
	type_timer.stop()
	still_typing = false
	char_text.visible_characters = char_text.text.length()

func _input(event):
	if event.is_action_pressed("accept"):
		if still_typing:
			type_timer.stop()
			char_text.visible_characters = char_text.get_parsed_text().length()
			still_typing = false
		else:
			current_line += 1
			show_line()

func _on_timer_timeout() -> void:
	var clean_text := char_text.get_parsed_text()
	
	if char_text.visible_characters < clean_text.length():
		char_text.visible_characters += 1

		var last_char := clean_text[char_text.visible_characters - 1]
		
		# 1. Calculamos el tiempo según el carácter actual
		match last_char:
			",":
				type_timer.wait_time = comma_pause
			".":
				type_timer.wait_time = dot_pause
			_:
				type_timer.wait_time = letter_speed
		type_timer.start()
	
		if talk_cooldown <= 0:
			var speaker = char_name.text
			if talk_sound_map.has(speaker):
				AudioController.play_sound(talk_sound_map[speaker])
			else:
				AudioController.play_sound("talk_default")
			talk_cooldown = 0.04
	else:
		type_timer.stop()
		still_typing = false
