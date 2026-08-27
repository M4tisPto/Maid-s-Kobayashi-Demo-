extends Area2D

signal died

@export var health := 45
var ded := false


func _on_area_entered(area: Area2D) -> void:
	if ded:
		return

	if area.is_in_group("bullet"):
		HitstopManager.hit_stop_enemy_hurt()
		take_damage(2)
		area.queue_free()

	elif area.is_in_group("player_spin"):
		HitstopManager.hit_stop_enemy_hurt() 
		take_damage(2)

	elif area.is_in_group("knuckle_attack_player"):
		HitstopManager.hit_stop_enemy_hurt() 
		take_damage(3)

	elif area.is_in_group("shockwave_player"):
		HitstopManager.hit_stop_enemy_hurt() 
		take_damage(2)

	elif area.is_in_group("player_attack_combo_1"):
		HitstopManager.hit_stop_enemy_hurt() 
		take_damage(1)

	elif area.is_in_group("player_attack_combo_2"):
		HitstopManager.hit_stop_enemy_hurt() 
		take_damage(2)

	elif area.is_in_group("player_attack_combo_3"):
		HitstopManager.hit_stop_enemy_hurt() 
		take_damage(3)


func take_damage(amount: float) -> void:
	if ded:
		return

	health -= amount
	print("damage left: ", health)

	if health <= 0:
		die()


func die() -> void:
	if ded:
		return

	ded = true

	var enemy = get_parent()

	# Desactivar todas las colisiones
	enemy.collision_hurtbox.set_deferred("disabled", true)
	enemy.collision_hitbox.set_deferred("disabled", true)
	enemy.main_collision.set_deferred("disabled", true)

	enemy.set_collision_mask_value(1, false)

	# Impulso de muerte
	enemy.velocity = Vector2(0, -500)

	# Animación
	enemy.sprite.play("death")

	# Efecto
	PlayerManager.shake_camera(2, 0.2)

	# Avisar al BossTrigger
	died.emit()

	# Esperar antes de eliminar
	await get_tree().create_timer(0.9).timeout

	enemy.queue_free()
