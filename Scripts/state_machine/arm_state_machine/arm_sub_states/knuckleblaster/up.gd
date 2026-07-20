extends State
var arm_animation_player: AnimationPlayer


func enter() -> void:
	print("up")
	if get_parent() and "animation_player" in get_parent():
		arm_animation_player = get_parent().animation_player
	
	# Ejecutamos la animación del shockwave
	if arm_animation_player:
		arm_animation_player.play("shockwavea_anim")


func exit() -> void:
	print("bye bye")
