#enemy hurtbox
extends Area2D
@export var health = 15
var ded = false

func _physics_process(delta: float) -> void:
	if ded:
		var enemy = get_parent()
		enemy.collision_hurtbox.set_deferred("disabled", true)
		enemy.rotation += 90 * delta * 0.2
		
		enemy.sprite.play("death")
		enemy.set_collision_mask_value(1, false)
func _on_area_entered(area):
	
	if area.is_in_group("bullet"):
		HitstopManager.hit_stop_enemy_hurt() 
		take_damage(2)
		area.queue_free()
	elif area.is_in_group("player_spin"):
		
		take_damage(2)
	elif area.is_in_group("knuckle_attack_player"):
		take_damage(3)
	elif area.is_in_group("shockwave_player"):
		take_damage(2)
	elif area.is_in_group("player_attack_combo_1"):

		take_damage(1)
	elif area.is_in_group("player_attack_combo_2"):
		take_damage(2)
	elif area.is_in_group("player_attack_combo_3"):
		take_damage(3)

func take_damage(ammount: float):
	health -= ammount
	print("damage left: ", health)
	
	if health <= 0:
		die()
func die():
	ded = true
	var enemy = get_parent()
	enemy.velocity.y = -500
	enemy.velocity.x = 0
	var player = get_tree().get_first_node_in_group("player")
	PlayerManager.shake_camera(2, 0.2)
