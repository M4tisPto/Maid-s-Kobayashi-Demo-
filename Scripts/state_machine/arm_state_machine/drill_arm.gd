extends State
@onready var neutral: Node = $neutral
@onready var foward: Node = $foward
@onready var up: Node = $up
@onready var down: Node = $down

var new_arm: State

var current_sub_attack = null
