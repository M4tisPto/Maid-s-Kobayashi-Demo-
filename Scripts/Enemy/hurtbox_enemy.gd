#enemy hurtbox
extends Area2D
@export var health = 16

func _on_area_entered(area):
	if area.is_in_group("bullet"):
		HitstopManager.hit_stop_enemy_hurt() 
		take_damage(0.5)
		area.queue_free()
	elif area.is_in_group("player_spin"):
		HitstopManager.hit_stop_enemy_hurt() 
		take_damage(2)
	elif area.is_in_group("knuckle_attack_player"):
		take_damage(3)
	elif area.is_in_group("shockwave_player"):
		take_damage(2)
	else:
		print("unknown area")

func take_damage(ammount: float):
	health -= ammount
	print("damage left: ", health)
	
	if health <= 0:
		die()
func die():
	var player = get_tree().get_first_node_in_group("player")
	PlayerManager.shake_camera(2, 0.2)
	get_parent().queue_free()
