extends Area2D

@export var damage = 3

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$AnimationPlayer.play("sword_swing")
	
	$AnimationPlayer.animation_finished.connect(func(_anim_name): queue_free())
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
