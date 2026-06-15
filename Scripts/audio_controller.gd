extends Node

@export var mute: bool = false


func play_music_test():
	if not mute:
		$Music/Music_lvl_test.play()

func stop_music_test():
	$Music/Music_lvl_test.stop()

func play_menu_music():
	if not mute:
		$Music/Music_menu.play()

func stop_menu_music():
	$Music/Music_menu.stop()

func play_jump():
	if not mute:
		$Sfx/Jump.play()

func stop_play_jump():
	$Sfx/Jump.stop()
