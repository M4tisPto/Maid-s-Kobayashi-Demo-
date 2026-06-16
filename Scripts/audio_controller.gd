extends Node

var sfx := {}
var music := {}

var current_music: AudioStreamPlayer = null


func _ready():
	sfx = {
		"jump": $Sfx/Jump,
		"punch": $Sfx/Punch,
		"test": $Sfx/test_sound
	}

	music = {
		"menu_music": $Music/Music_menu,
		"level_test_music": $Music/Music_lvl_test,
		"credits": $Music/Credits_theme
	}


func play_sound(sound_name: String):
	if sfx.has(sound_name):
		sfx[sound_name].play()


func stop_sound(sound_name: String):
	if sfx.has(sound_name):
		sfx[sound_name].stop()


func play_music(music_name: String):
	if music.has(music_name):
		
		if current_music:
			current_music.stop()

		current_music = music[music_name]
		current_music.play()


func stop_music():
	if current_music:
		current_music.stop()
		current_music = null
