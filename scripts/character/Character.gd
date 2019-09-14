extends "res://scripts/agent/Agent.gd" # extends KinematicBody2D

signal animation_finished

export(float) var gravity = 9.8
export(float) var speed = 300.0
export(float) var max_speed = 10000
export(float) var fast_fall = 300
export(float) var max_fall_speed = 300
export(float) var max_jump_horizontal_speed = 160
export(float) var scaling_smoothing = 1

var movement = Vector2()
var gravity_force = 0

func _ready():
	self.connect("consumed", self, "_agent_consumed")

func _physics_process(delta):
	move(delta)
	$CharacterScaling.scale_size(delta)
	
####################
# methods
func move(delta):
	movement.x += user_input().x * speed * delta
	clamp(movement.x, -max_speed, max_speed)
	
	if user_input().x == 0:
		stop_moving()
		
	if is_on_floor():
		gravity_force = 0
		print('please')
	else:
		gravity_force += gravity * delta
		movement.y += gravity_force
		movement.y += user_input().y * fast_fall * delta
		clamp(movement.y, 0, max_fall_speed)
		print("skyman")
	print(is_on_floor())
	move_and_slide(movement, Vector2(0,-1))
	
func user_input():
	var input = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down"))
	return input
	
# TODO have logic for slowly stopping
func stop_moving():
	movement.x = 0
	
####################
# event listeners
func _agent_consumed(attributes_mutated):
	for attribute in attributes_mutated:
		match attribute:
			"body_size":
				$CharacterScaling.set_body_scaling(self.body_size)
			"health":
				pass # TODO: emit health changed signal for some UI 

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animation_finished", anim_name)
