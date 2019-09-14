extends KinematicBody2D

# exported attributes
export var gravity: Vector2 = Vector2(0, -500)
export var speed : float = 5000
export var max_speed : float = 200
export var max_jump_horizontal_speed : float = 160
export var jump_height : float = -500
export var extra_jump_total : int = 1
export var jump_early_cancel_velocity_multiplier = 0.5

# attributes
var extra_jumps = 1
var invulnerability = 0  # duration in (unit of time) char is invulnerable
var friction = false
var motion = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	friction = false
	move(delta)
#	air_controls()
	
func move(delta):
	if (invulnerability > 0):
		invulnerability -= delta
	
	motion.x = int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left"))
	#move_vec.y = int(Input.get_action_strength("move_down")) - int(Input.get_action_strength("move_up"))

	if motion == Vector2.ZERO:
		stop_running()
		
	#move_vec -= gravity

	#move_vec = move_vec.normalized()
	var new_pos = motion * speed * delta
	new_pos -= gravity
	move_and_slide(new_pos, Vector2(0,-1))
	
func stop_running():
	friction = true
	motion.x = lerp(motion.x, 0, 0.2)
	
func air_controls():
	if Input.is_action_just_pressed("jump") && is_on_floor():
		extra_jumps = extra_jump_total
		motion.y = jump_height
	elif Input.is_action_just_released("jump"):
		if(motion.y < 0):
			motion.y = motion.y * jump_early_cancel_velocity_multiplier
	elif extra_jumps > 0 && Input.is_action_just_pressed("jump"):
		motion.y = 0
		motion.y = motion.y + jump_height
		extra_jumps -= 1
		
	if friction:
		motion.x = lerp(motion.x, 0, 0.2)
	if !is_on_floor():
		during_air_time()
		
func during_air_time():
	if motion.y < 0:
		$AnimationPlayer.play("jump")
	else:
		$AnimationPlayer.play("fall")
	if friction:
		motion.x = lerp(motion.x,0,0.05)