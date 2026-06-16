extends Node2D

var level: int = 1
var fullscreen := false


func _ready() -> void:
	AudioController.play_music("menu_music")
	$CenterContainer/MainButtons/play.grab_focus()
	$CenterContainer/SettingsMenu/fullscreen.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else DisplayServer.WINDOW_MODE_WINDOWED
	$CenterContainer/SettingsMenu/mainvoslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$CenterContainer/SettingsMenu/musicvoslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$CenterContainer/SettingsMenu/sfxvoslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx")))
func _on_play_pressed() -> void:
	AudioController.stop_music()
	get_tree().change_scene_to_file("res://Scenes/Levels/test_level.tscn")
	# get_tree().change_scene_to_file(str("res://Scenes/Levels", level, ".tscn")) 46


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("BUT C PAPU MISTERIOSO TE CIERRA EL JUEGO")



func _on_settings_pressed() -> void:
	$CenterContainer/MainButtons.visible = false
	$CenterContainer/SettingsMenu.visible = true


func _on_credits_pressed() -> void:
	AudioController.stop_music()
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_quit_pressed() -> void:
	print("BUT C PAPU MISTERIOSO TE CIERRA EL JUEGO")
	get_tree().quit()


func _on_back_pressed() -> void:
	$Title.visible = true
	$CenterContainer/MainButtons.visible = true
	$CenterContainer/CreditsMenu.visible = false
	$CenterContainer/SettingsMenu.visible = false


func _on_test_sound_pressed() -> void:
	AudioController.play_sound("test")


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	fullscreen = toggled_on
	
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _on_mainvoslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)




func _on_musicvoslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)


func _on_sfxvoslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Sfx"), value)
