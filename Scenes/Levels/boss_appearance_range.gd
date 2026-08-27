extends Area2D
# boss appear

@onready var camera_limit: PlayerCamera = $"../player/CameraPlayer"

var boss_appear = preload("res://Scenes/Enemies/mini_boss.tscn")

var original_zoom: Vector2
var original_limit_left: int
var original_limit_top: int
var original_limit_right: int
var original_limit_bottom: int

var boss_started := false
var boss_instance: Node = null


func _ready() -> void:
	original_zoom = camera_limit.zoom
	original_limit_left = camera_limit.limit_left
	original_limit_top = camera_limit.limit_top
	original_limit_right = camera_limit.limit_right
	original_limit_bottom = camera_limit.limit_bottom


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	# Evita que se vuelva a activar
	if boss_started:
		return

	boss_started = true

	# Bloquear la arena
	$"../boss_ring_or_smth/CollisionShape2D".set_deferred("disabled", false)
	$"../boss_ring_or_smth/CollisionShape2D2".set_deferred("disabled", false)

	# Desactivar el trigger
	$CollisionShape2D.set_deferred("disabled", true)

	# Cambiar cámara
	var tween := create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)

	tween.tween_property(camera_limit, "zoom", Vector2(1, 1), 0.5)
	tween.tween_property(camera_limit, "limit_left", 235, 0.8)
	tween.tween_property(camera_limit, "limit_top", -399, 0.8)
	tween.tween_property(camera_limit, "limit_right", 1023, 0.8)
	tween.tween_property(camera_limit, "limit_bottom", 40, 0.8)


	await tween.finished

	await get_tree().create_timer(1.5).timeout


	boss_instance = boss_appear.instantiate()

	$"../".add_child(boss_instance)

	boss_instance.global_position = Vector2(900, -100)



	await boss_instance.tree_exited


	restore_arena()


func restore_arena() -> void:
	# Restaurar cámara
	var tween := create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)

	tween.tween_property(camera_limit, "zoom", Vector2(2.5, 2.5), 0.8)
	tween.tween_property(camera_limit, "limit_left", -126, 0.8)
	tween.tween_property(camera_limit, "limit_top", -607, 0.8)
	tween.tween_property(camera_limit, "limit_right", 4647, 0.8)
	tween.tween_property(camera_limit, "limit_bottom", 176, 0.8)

	$"../boss_ring_or_smth/CollisionShape2D".set_deferred("disabled", true)
	$"../boss_ring_or_smth/CollisionShape2D2".set_deferred("disabled", true)

	var boss_hurtbox = boss_instance.get_node("Hurtbox")

	await boss_hurtbox.died

	restore_arena()
