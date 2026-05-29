extends Node

@export var mute: bool = false

func play_music_test() -> void:
	if not mute:
		$Music_lvl_test.play()

func stop_music_test() -> void:
	$Music_lvl_test.stop()


func play_music_menu() -> void:
	if not mute:
		$Music_menu.play()

func stop_music_menu() -> void:
	$Music_menu.stop()


func play_jump() -> void:
	if not mute:
		$Jump.play()
