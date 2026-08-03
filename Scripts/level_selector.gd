@tool
extends Node2D
class_name CarouselContainer

@export var spacing: float = 20.0
@export var wraparound_enabled: bool = false
@export var wraparound_radius: float = 300.0
@export var wraparound_height: float = 50.0
@export_range(0.0, 1.0) var opacity_strength: float = 0.35
@export_range(0.0, 1.0) var scale_strength: float = 0.25
@export_range(0.01, 0.99, 0.01) var scale_min: float = 0.1
@export var smoothing_speed: float = 6.5
@export var selected_index: int = 0
@export var follow_button_focus: bool = false
@export var position_offset_node: Control = null

func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() == 0:
		return
		
	var child_count = position_offset_node.get_child_count()
	selected_index = clamp(selected_index, 0, child_count - 1)
	
	for i in position_offset_node.get_children():
		var idx = i.get_index()
		var dist = abs(idx - selected_index)
		
		if wraparound_enabled:
			var max_index_range = max(1.0, (child_count - 1) / 2.0)
			var angle = clamp((idx - selected_index) / max_index_range, -1.0, 1.0) * PI
			var x = sin(angle) * wraparound_radius
			var y = cos(angle) * wraparound_height
			var target_pos = Vector2(x, y - wraparound_height) - i.size / 2.0
			i.position = i.position.lerp(target_pos, smoothing_speed * delta)
		else:
			var position_x = 0.0
			if idx > 0:
				var prev_child = position_offset_node.get_child(idx - 1)
				position_x = prev_child.position.x + prev_child.size.x + spacing
			i.position = i.position.lerp(Vector2(position_x, -i.size.y / 2.0), smoothing_speed * delta)
			
		i.pivot_offset = i.size / 2.0
		
		var target_scale = clamp(1.0 - (scale_strength * dist), scale_min, 1.0)
		i.scale = i.scale.lerp(Vector2.ONE * target_scale, smoothing_speed * delta)
		
		var target_opacity = clamp(1.0 - (opacity_strength * dist), 0.0, 1.0)
		i.modulate.a = lerp(i.modulate.a, target_opacity, smoothing_speed * delta)
		
		if idx == selected_index:
			i.z_index = 1
			i.mouse_filter = Control.MOUSE_FILTER_STOP
			i.focus_mode = Control.FOCUS_ALL
		else:
			i.z_index = -int(dist)
			i.mouse_filter = Control.MOUSE_FILTER_IGNORE
			i.focus_mode = Control.FOCUS_NONE
			
		if follow_button_focus and i.has_focus():
			selected_index = idx
			
	if wraparound_enabled:
		position_offset_node.position.x = lerp(position_offset_node.position.x, 0.0, smoothing_speed * delta)
	else:
		var selected_node = position_offset_node.get_child(selected_index)
		var target_offset_x = -(selected_node.position.x + selected_node.size.x / 2.0)
		position_offset_node.position.x = lerp(position_offset_node.position.x, target_offset_x, smoothing_speed * delta)

func _left() -> void:
	if position_offset_node:
		selected_index = wrapi(selected_index - 1, 0, position_offset_node.get_child_count())

func _right() -> void:
	if position_offset_node:
		selected_index = wrapi(selected_index + 1, 0, position_offset_node.get_child_count())
