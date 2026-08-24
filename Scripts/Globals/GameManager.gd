extends Node

var player: Player
var player_health: int = 25
var current_arm: String = "base"
var is_collisions_checked: bool = false

func save_player(player: Player) -> void:
	if not player:
		return
	
	if player.health_component:
		player_health = player.health_component.health
	
	if player.arm_state_machine:
		if player.arm_state_machine.current_state:
			current_arm = player.arm_state_machine.current_state.name
	
	print("guardando datos")


func load_player(player: Player) -> void:
	if not player:
		return

	# Cargar vida
	if player.health_component:
		player.health_component.health = player_health
		player.health_gui.text = "Health: " + str(player_health)

	# Cargar brazo
	if player.arm_state_machine:
		load_arm(player)
	
func load_arm(player: Player) -> void:

	match current_arm:

		"base":
			player.arm_state_machine.change_state(
				player.arm_state_machine.get_node("base")
			)

		"knuckleblaster_arm":
			player.arm_state_machine.change_state(
				player.arm_state_machine.get_node("knuckleblaster_arm")
			)

		"drill_arm":
			player.arm_state_machine.change_state(
				player.arm_state_machine.get_node("drill_arm")
			)

		_:
			print("Unknown arm: ", current_arm)



func reset_player_data() -> void:
	player_health = 25
	current_arm = "base"
