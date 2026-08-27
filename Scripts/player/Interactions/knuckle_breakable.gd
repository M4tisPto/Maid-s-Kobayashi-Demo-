extends StaticBody2D


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("knuckle_attack_player"):
		$AnimationPlayer.play("Destroyed")
		$hitbox/CollisionShape2D2.visible = false
		await $AnimationPlayer.animation_finished
		queue_free()
	if area.is_in_group("shockwave_player"):
		$AnimationPlayer.play("Destroyed")
		$hitbox/CollisionShape2D2.visible = false
		await $AnimationPlayer.animation_finished
		queue_free()
