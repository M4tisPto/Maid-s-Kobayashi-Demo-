extends RichTextLabel

@export var speed: float = 10.0
@export var amplitude: float = 0.1
var initial_y: float
var random_time_offset: float = 0.0

func _ready() -> void:
	initial_y = scale.y
	random_time_offset = randf_range(0.0, 100.0)

func _process(delta: float) -> void:
	var time = (Time.get_ticks_msec() / 1000.0) + random_time_offset
	scale.x = 1.0 + sin(time * speed) * amplitude
	scale.y = 1.0 + sin(time * speed) * amplitude
