extends KinematicBody2D

export(float) var speed = 300.0

func _physics_process(delta):
	var movement = Vector2()
	
	if Input.is_action_pressed("move_right"):
		movement += Vector2.RIGHT
		
	print(movement)
	position += movement * speed * delta