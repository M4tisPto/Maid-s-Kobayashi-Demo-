extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	velocity = Vector2(200, 150)
	change_color()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var normal = collision.get_normal()
		velocity = velocity.bounce(normal)
		
		change_color()


func change_color():
	#sprite_2d.modulate = Color(0, 0, 255)
	sprite_2d.modulate = Color.from_hsv(randf(), 0.5, 1.0)
