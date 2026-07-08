#enemy hurtbox
extends Area2D
var health = 2

func _on_area_entered(area):
	if area.is_in_group("player_attack"):
		take_damage(1)

func take_damage(ammount: float):
	health -= ammount
	print("damage left: ", health)
	
	if health <= 0:
		die()
func die():
	var player = get_tree().get_first_node_in_group("player")
	PlayerManager.shake_camera(2, 0.2)
	get_parent().queue_free()
