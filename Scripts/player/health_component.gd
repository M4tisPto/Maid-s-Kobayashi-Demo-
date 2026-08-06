extends Node2D
# health omponent
signal died

@export var MAX_HEALTH := 8.0

var health : float

func _ready():
	health = MAX_HEALTH


func damage(ammount: float, strenght: float):
	health -= ammount
	print("HP:", health)
	if health <= 0:
		died.emit()
