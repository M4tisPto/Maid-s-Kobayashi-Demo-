extends TabBar

class_name AnimatedTabBar

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

var last_hovered_tab: int = -1

func _ready() -> void:
	initial_y = position.y
	style_box = get_theme_stylebox("tab_hover") as StyleBoxFlat
	random_time_offset = randf_range(0.0, 100.0)
	
	offset_transform_enabled = true 
	
	# Conexiones limpias mediante señales nativas de Godot 4
	tab_hovered.connect(_on_tab_hovered)
	tab_changed.connect(_on_tab_changed)
	mouse_exited.connect(_on_mouse_exited_bar)

func _on_tab_hovered(tab_idx: int) -> void:
	# Si ya estábamos encima de esta pestaña, ignoramos
	if tab_idx == last_hovered_tab:
		return
		
	last_hovered_tab = tab_idx
	
	if _tween:
		_tween.kill()
	_tween = create_tween()
	
	add_theme_color_override("font_hovered_color", Color.BLACK)
	
	_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(self, "offset_transform_scale", HOVER_SCALE, 0.35)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0.2 * scale_ratio * [-1.0, 1.0].pick_random(), 0.1)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0.0, 0.1).set_delay(0.1)

func _on_mouse_exited_bar() -> void:
	# Resetea la escala cuando el mouse sale por completo del área del TabBar
	last_hovered_tab = -1
	_animate_to_rest()

func _on_tab_changed(_tab_idx: int) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	
	# Efecto Squash al cambiar la pestaña activa
	_tween.tween_property(self, "offset_transform_scale", SQUASH_SCALE, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(self, "offset_transform_scale", REST_SCALE, 0.2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _animate_to_rest() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	
	add_theme_color_override("font_selected_color", Color.WHITE)
	add_theme_color_override("font_unselected_color", Color.GRAY)
	
	_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(self, "offset_transform_scale", REST_SCALE, 0.2)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0.0, 0.1).set_delay(0.1)
	_tween.parallel().tween_property(self, "offset_transform_rotation", 0.2 * scale_ratio * [-1.0, 1.0].pick_random(), 0.1)
