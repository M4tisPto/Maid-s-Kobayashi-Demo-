extends Node

func hit_stop_death():
	AudioController.stop_music()
	AudioController.play_sound("player_hurt")
	
	# 1. Un temblor fuerte pero muy rápido para el impacto inicial (fuerza 1.0, dura 0.2 segundos)
	PlayerManager.shake_camera(25.0, 0.3)
	
	await get_tree().create_timer(0.3, true, false, true).timeout

	# Se detiene el juego por completo
	Engine.time_scale = 0

	await get_tree().create_timer(1.5, true, false, true).timeout
	PlayerManager.shake_camera(5, 1.5)
	Engine.time_scale = 0.3
	
	AudioController.play_sound("player_death")

	await get_tree().create_timer(3.0, true, false, true).timeout


func hit_stop_hurt():
	AudioController.play_sound("player_hurt")
	
	PlayerManager.shake_camera(8.0, 0.5)
	
	var previous_time_scale = Engine.time_scale
	
	Engine.time_scale = 0.0
	await get_tree().create_timer(0.08, true, false, true).timeout
	
	Engine.time_scale = previous_time_scale


func hit_stop_enemy_hurt():
		PlayerManager.shake_camera(8.0, 0.5)
