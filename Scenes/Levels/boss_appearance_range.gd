extends Area2D
# boss appear


@onready var camera_limit: PlayerCamera = $"../player/CameraPlayer"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var tween = create_tween()
		
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_parallel(true) 
		
		tween.parallel().tween_property(camera_limit, "zoom", Vector2(1, 1), 0.5)
		tween.tween_property(camera_limit, "limit_left", 235, 0.8)
		tween.tween_property(camera_limit, "limit_top", -399, 0.8)
		tween.tween_property(camera_limit, "limit_right", 1023, 0.8)
		tween.tween_property(camera_limit, "limit_bottom", 40, 0.8)
		$"../boss_ring_or_smth/CollisionShape2D".set_deferred("disabled", false)
		$"../boss_ring_or_smth/CollisionShape2D2".set_deferred("disabled", false)
		$CollisionShape2D.set_deferred("disabled", true)

# then idk how to do that when the mini boss dies all will be back to normal (both lmit camera and alldat)
