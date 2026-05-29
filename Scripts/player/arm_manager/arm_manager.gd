extends Node

var current_arm
var player

func setup(_player):
	player = _player

func set_arms(arm_scene):
	if current_arm:
		current_arm.queue_free()

	current_arm = arm_scene.instantiate()
	add_child(current_arm)

	current_arm.setup(player)
