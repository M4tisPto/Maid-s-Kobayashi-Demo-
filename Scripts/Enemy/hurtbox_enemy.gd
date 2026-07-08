#enemy hurtbox
extends Area2D
var health = 5

func _on_area_entered(area):
	if area.is_in_group("player_attack"):
		take_damage(1, area.global_position)

func take_damage(ammount: float, attack_position: Vector2):
	health -= ammount
	print("damage left: ", health)
	
	if health <= 0:
		die()
	else:
		var enemy = get_parent()
		if enemy.has_method("apply_knockback"):
			enemy.apply_knockback(attack_position)
func die():
	var player = get_tree().get_first_node_in_group("player")
	PlayerManager.shake_camera(2, 0.2)
	get_parent().queue_free()
