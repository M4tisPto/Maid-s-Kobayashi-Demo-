extends Node

var sfx := {}
var music := {}
var current_music: AudioStreamPlayer = null 

func _ready():
	sfx = {
		"jump": $Sfx/Jump,
		"punch": $Sfx/Punch,
		"test": $Sfx/test_sound,
		"player_hurt": $Sfx/PlayerHurt,
		"player_death": $Sfx/PlayerDeath,
		"talk_test": $Sfx/talk_test,
		"talk_sophia": $Sfx/Sophia_talk,
		"talk_default": $Sfx/Default_talk,
		"talk_matis": $Sfx/Matis_talk,
		"WOAHGUYSDIDYOUSEETHAT":$Sfx/DIDYOUGUYSSEETHAT
	}

	music = {
		"menu_music": $Music/Music_menu,
		"level_test_music": $Music/Music_lvl_test,
		"credits": $Music/Credits_theme
	}
	
func play_sound(sound_name: String):
	if not sfx.has(sound_name):
		return 

	var sound = sfx[sound_name]
	sound.pitch_scale = 1.0

	# Simplificación de la lógica de pitch aleatorio
	if sound_name.begins_with("punch") or sound_name.begins_with("talk_"):
		sound.pitch_scale = randf_range(0.95, 1.1)

	sound.play()

func stop_sound(sound_name: String):
	if sfx.has(sound_name):
		sfx[sound_name].stop()

func play_music(song_name: String, volume: float = 0.0) -> void:
	if not music.has(song_name):
		return
	
	if current_music:
		current_music.stop()
	
	current_music = music[song_name]
	current_music.volume_db = volume
	current_music.play()

func stop_music():
	if current_music:
		current_music.stop()
		current_music = null
