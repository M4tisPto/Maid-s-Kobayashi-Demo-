extends Node2D
# health omponent
signal died
@onready var health_gui: Label = $"../GUI/Label2"

@export var MAX_HEALTH := 25

var health : int

func _ready():
	health = MAX_HEALTH
	health_gui.text = "Health: " + str(health)


func damage(ammount: float, strenght: float):
	health -= ammount
	health_gui.text = "Health: " + str(health)
	if health <= 0:
		died.emit()
