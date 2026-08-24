extends CanvasLayer
#
func _ready() -> void:
	visible = true
	var chance_timer = Timer.new()
	chance_timer.wait_time = 1.0
	chance_timer.autostart = true
	add_child(chance_timer)
	
	chance_timer.timeout.connect(_on_chance_timer_timeout)

func _on_chance_timer_timeout() -> void:
	if randi_range(1, 500) == 1:
		AudioController.play_sound("WOAHGUYSDIDYOUSEETHAT")
		$AnimatedSprite2D/AnimationPlayer.play("did_you_see_that")
