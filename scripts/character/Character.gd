extends "res://scripts/agent/Agent.gd" # extends KinematicBody2D

export(float) var gravity = 9.8
export(float) var speed = 100.0
export(float) var max_speed = 400
export(float) var fast_fall = 20
export(float) var jump_speed = 500
export(float) var max_jump_horizontal_speed = 320
export(float) var scaling_smoothing = 1

onready var sprite = $SlimeSprite
onready var animator = $SlimeSprite/AnimationPlayer

var movement = Vector2()
var full_jump = false
var friction = false


####################
# core
func _ready():
	self.connect("consumed", self, "_agent_consumed")
	animator.connect("animation_finished", self, "_on_SlimeSprite_animation_finished")

func _physics_process(delta):
	move(delta)
	$CharacterScaling.scale_size(delta)

####################
# input
func user_input():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("jump")
	)

####################
# movement
func move(delta):
	movement.y += gravity
	var user_input = user_input()

	friction = false

	if user_input.x == 1:
		run_right()
	elif user_input.x == -1:
		run_left()
	else:
		stopped_running()

	air_controls()
#	print(movement)
	if not is_dead():
		movement = move_and_slide(movement, Vector2.UP)

func run_right():
	if !is_on_floor():
		movement.x = lerp(movement.x, max_jump_horizontal_speed, 0.15)
	else:
		movement.x = min(movement.x + speed, max_speed)
	sprite.flip_h = true

func run_left():
	if !is_on_floor():
		movement.x = lerp(movement.x, -max_jump_horizontal_speed, 0.15)
	else:
		movement.x = max(movement.x -speed, -max_speed)
	sprite.flip_h = false

func stopped_running():
	friction = true
	movement.x = lerp(movement.x, 0, 0.2)

func air_controls():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		movement.y = -jump_speed / 2
		$JumpTimer.start()
		full_jump = false
	elif Input.is_action_pressed("jump"):
		if ($JumpTimer.time_left <= $JumpTimer.wait_time / 5) and not full_jump:
			full_jump = true
			movement.y = -jump_speed

	if user_input().y == 1:
		movement.y += fast_fall

	if friction:
		movement.x = lerp(movement.x, 0, 0.2 if is_on_floor() else 0.05)

####################
# health
func die():
	.die() # set dead = true
	animator.play("death")
	
func is_dead():
	.is_dead()

####################
# event listeners
func _agent_consumed(attributes_mutated):
	for attribute in attributes_mutated:
		match attribute:
			"body_size":
				$CharacterScaling.set_body_scaling(self.body_size)
			"health":
				pass # TODO: emit health changed signal for some UI

func _on_SlimeSprite_animation_finished(anim_name):
	match anim_name:
		"death":
			queue_free()

func _on_JumpTimer_timeout():
	full_jump = true
