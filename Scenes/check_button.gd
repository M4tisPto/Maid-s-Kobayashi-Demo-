extends CheckButton


func _on_toggled(toggled_on: bool) -> void:
	print(toggled_on)
	GameManager.is_collisions_checked = toggled_on
