extends Panel

@export var speed: float = 1.5
@export var amplitude: float = 2.0
var time_offset: float = 15
var initial_y: float



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = (Time.get_ticks_msec() / 1000.0) + time_offset
	position.y = initial_y + sin(time * speed) * amplitude
