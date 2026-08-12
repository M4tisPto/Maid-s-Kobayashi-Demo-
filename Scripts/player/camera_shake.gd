class_name PlayerCamera extends Camera2D

@onready var player: Player = $".."

@export_range(0, 1, 0.05, "or_greator") var shake_power: float = 0.5 # Overall Strengtk of shake
@export var shake_max_offset: float = 5.0 # Maximun shake in pixels
@export var shake_decay: float = 1.0 # How quicly the shake stops
var shake_trauma: float = 0.0
var look_ahead = 20
var lerp_speed = 5

func _ready() -> void:
	PlayerManager.camera_shook.connect( add_camera_shake )

func _physics_process(delta: float) -> void:
	if shake_trauma > 0:
		shake_trauma = max( shake_trauma - shake_decay * delta, 0)
		shake()
	if player.velocity.x > 0:
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "position", Vector2(130, -40.0), 0.5)
		tween.parallel().tween_property(self, "zoom", Vector2(1.5, 1.5), 0.5)



func add_camera_shake(intensity: float, duration: float = 0.5) -> void:
	shake_trauma = clamp(shake_trauma + intensity, 0.0, 1.0)
	if duration > 0.0:
		shake_decay = 1.0 / duration


func shake() -> void:
	var ammount : float = pow( shake_trauma * shake_power, 2)
	offset = Vector2( randf_range(-1, 1), randf_range(-1, 1) * shake_max_offset * ammount)
