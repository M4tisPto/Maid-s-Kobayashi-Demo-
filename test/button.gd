extends Button

class_name AnimatedButton

@export var speed: float = 2.0
@export var amplitude: float = 8.0
var random_time_offset: float = 0.0

const REST_SCALE := Vector2.ONE
const HOVER_SCALE := Vector2(1.1, 1.1)
const SQUASH_SCALE := Vector2(1.15, 0.9)


var style_box: StyleBoxFlat
var default_color: Color = Color.WHITE
var hover_color: Color = Color.WHITE
var _tween: Tween = null
var initial_y: float
var scale_ratio := 1.2

var is_hovered = false
func _ready() -> void:
	initial_y = position.y
	style_box = get_theme_stylebox("hover") as StyleBoxFlat
	random_time_offset = randf_range(0.0, 100.0)
	offset_transform_enabled = true
	mouse_entered.connect(_on_anim_button_mouse_entered)
	mouse_exited.connect(_on_anim_button_mouse_exited)
	button_down.connect(_on_anim_button_button_down)


func _process(delta: float) -> void:

	var time = (Time.get_ticks_msec() / 1000.0) + random_time_offset
	position.y = initial_y + sin(time * speed) * amplitude

func _restart_tween() -> Tween:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	return _tween

func _on_anim_button_mouse_entered() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	add_theme_color_override("font_hover_color", Color.BLACK)
	_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(self, "offset_transform_scale", HOVER_SCALE, 0.35)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0.2 * scale_ratio * [-1-0, 1.0].pick_random(), 0.1)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0.0, 0.1).set_delay(0.1)
	
func _on_anim_button_mouse_exited() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	add_theme_color_override("font_color", Color.WHITE)
	_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(self, "offset_transform_scale", REST_SCALE, 0.2)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0.0, 0.1).set_delay(0.1)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0.2 * scale_ratio * [-1-0, 1.0].pick_random(), 0.1)

func _on_anim_button_button_down() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "offset_transform_scale", SQUASH_SCALE, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(self, "offset_transform_scale", REST_SCALE, 0.2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
