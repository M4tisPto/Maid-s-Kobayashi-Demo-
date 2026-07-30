extends RichTextLabel


@export var speed: float = 0.5
@export var amplitude: float = 8.0
var initial_y: float
var random_time_offset: float = 0.0


func _ready() -> void:
	initial_y = rotation_degrees
	random_time_offset = randf_range(0.0, 100.0)

func _process(delta: float) -> void:
	var time = (Time.get_ticks_msec() / 1000.0) + random_time_offset
	rotation_degrees = initial_y + sin(time * speed) * amplitude
