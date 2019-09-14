extends KinematicBody2D

export(float) var speed = 300.0


func _physics_process(delta):
	var movement = Vector2()
	
	if Input.is_action_pressed("move_right"):
		movement += Vector2.RIGHT
	if Input.is_action_pressed("move_down"):
		movement += Vector2.DOWN
	if Input.is_action_pressed("move_left"):
		movement += Vector2.LEFT
	if Input.is_action_pressed("move_up"):
		movement += Vector2.UP
		
	position += movement * speed * delta