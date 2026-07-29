extends Button


@export var focus_push_x: float = 10
@export var focus_scale: float = 1.4
@export var focus_z : int = 100
@export var anim_time: float = 0.12

var _base_position: Vector2
var _base_scale: Vector2
var _base_rotation: float
var _tween: Tween 


func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_entered.connect(grab_focus)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	
	_base_position = position
	_base_scale = scale
	_base_rotation = rotation_degrees
	pivot_offset = Vector2(0.0, size.y * 0.5)

func _on_focus_entered() -> void:
	z_index = focus_z
	
	if get_parent():
		get_parent().move_child(self, -1)
	
	_kill_tween()
	_tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position", _base_position + Vector2(focus_push_x, 0.0), anim_time)
	_tween.tween_property(self, "scale", _base_scale * focus_scale, anim_time)
	_tween.tween_property(self, "rotation_degrees", 0, anim_time)


func _on_focus_exited() -> void:
	z_index = 0
	
	_kill_tween()
	_tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position", _base_position, anim_time)
	_tween.tween_property(self, "scale", _base_scale, anim_time)
	_tween.tween_property(self, "rotation_degrees", _base_rotation, anim_time)


func _kill_tween() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
