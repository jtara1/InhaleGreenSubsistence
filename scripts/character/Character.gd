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

var friction = false

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

	friction = false

	if user_input().x == 1:
		run_right()
	elif user_input().x == -1:
		run_left()
	else:
		stopped_running()

	air_controls()

	movement = move_and_slide(movement, Vector2.UP)

func run_right():
	if !is_on_floor():
		movement.x = lerp(movement.x, max_jump_horizontal_speed, 0.15)
	else:
		movement.x = min(movement.x + speed, max_speed)
	sprite.flip_h = true
	animator.play("move")

func run_left():
	if !is_on_floor():
		movement.x = lerp(movement.x, -max_jump_horizontal_speed, 0.15)
	else:
		movement.x = max(movement.x -speed, -max_speed)
	sprite.flip_h = false
	animator.play("move")

func stopped_running():
	animator.play("idle")
	friction = true
	movement.x = lerp(movement.x, 0, 0.2)

func air_controls():
	if user_input().y == -1 and is_on_floor():
		movement.y = -jump_speed

	if user_input().y == 1 and !is_on_floor():
		movement.y += fast_fall

	if friction == true:
		movement.x = lerp(movement.x, 0, 0.2)
	if !is_on_floor():
		during_air_time()

func during_air_time():
	if movement.y < 0:
		animator.play("jump")
	else:
		animator.play("fall")
	if friction == true:
		movement.x = lerp(movement.x, 0, 0.05)

####################
# health
func die():
	animator.play("death")

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