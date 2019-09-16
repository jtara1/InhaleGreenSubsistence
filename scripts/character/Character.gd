extends "res://scripts/agent/Agent.gd" # extends KinematicBody2D
class_name Character

signal character_died

export(float) var gravity = 9.8
export(float) var speed = 100.0
export(float) var max_speed = 400
export(float) var fast_fall = 20
export(float) var jump_speed = 500
export(float) var max_jump_horizontal_speed = 320
export(float) var wall_slide_speed = 35
export(float) var wall_jump_x_force = 700
export(float) var scaling_smoothing = 1
export(float) var hook_shot_length = 200
export(float) var hook_shot_strength = 50
export(float) var init_body_size_multiplier = -1 # let inherited value from Agent decide

onready var Vector2f = get_node("/root/Vector2f")
onready var sprite = $SlimeSprite
onready var animator = $SlimeSprite/AnimationPlayer
onready var raycast = $RayCast2D

var movement = Vector2()
var full_jump = false
var friction = false
var raycast_direction
var sprite_direction = Vector2(1,0)
var using_hookshot = false
var hookshot_coolingdown = false
var wall_clinging = false
#var can_jump = false
var target = Vector2()
var user_input = Vector2()

####################
# core
func _ready():
	self.connect("consumed", self, "_agent_consumed")
	animator.connect("animation_finished", self, "_on_SlimeSprite_animation_finished")
	
	if init_body_size_multiplier != -1:
		body_size = init_body_size_multiplier
		$CharacterScaling.set_body_scaling(body_size)

func _physics_process(delta):
	move(delta)
	$CharacterScaling.scale_size(delta)

####################
# input
func user_input():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
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
	hook_shot()
	
	if not is_dead():
		movement = move_and_slide(movement, Vector2.UP)

func run_right():
	if !is_on_floor():
		movement.x = lerp(movement.x, max_jump_horizontal_speed, 0.15)
	else:
		movement.x = min(movement.x + speed, max_speed)
		animator.play("roll", -1, 3.3)
				
	sprite.flip_h = true

func run_left():
	if !is_on_floor():
		movement.x = lerp(movement.x, -max_jump_horizontal_speed, 0.15)
	else:
		movement.x = max(movement.x -speed, -max_speed)
		animator.play("roll", -1, 3.3)
		
	sprite.flip_h = false

func stopped_running():
	friction = true
	movement.x = lerp(movement.x, 0, 0.2)

# TODO add a generic grace period when falling to jump
func air_controls():
	if Input.is_action_pressed("jump") and is_on_floor() and not using_hookshot:
		movement.y = -jump_speed / 2
		$JumpTimer.start()
		full_jump = false
		animator.play("jump", -1, 2.2) # x2.2 speed
	elif Input.is_action_pressed("jump"):
		if ($JumpTimer.time_left <= $JumpTimer.wait_time / 5) and not full_jump:
			full_jump = true
			movement.y = -jump_speed

	if user_input().y == 1:
		movement.y += fast_fall

	if friction:
		movement.x = lerp(movement.x, 0, 0.2 if is_on_floor() else 0.05)

####################
# hookshot
func hook_shot():
	raycast_direction = sprite_direction() * hook_shot_length
	raycast.cast_to = raycast_direction
	if Input.is_action_just_pressed("shoot") and not hookshot_coolingdown:
		# TODO make it so only certain objects are grabbable
		if raycast.is_colliding():
			# TODO create new animation for hooking onto wall
			target = raycast.get_collision_point()
			animator.play("shoot", -1, 5)
			$HookTravelTimer.start()
			$HookDelayTimer.start()
			using_hookshot = true
			hookshot_coolingdown = true
			

	if using_hookshot:
		global_position = Vector2f.lerp(global_position, target, 0.15)
			
func sprite_direction():
	sprite_direction = user_input()
	if sprite_direction.y > 0:
		sprite_direction.y = 0
	elif sprite_direction == Vector2.ZERO:
		if sprite.flip_h:
			sprite_direction = Vector2(1, 0)
		else:
			sprite_direction = Vector2(-1, 0)
	return sprite_direction.normalized()

####################
# health
func die():
	.die() # set dead = true
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
			emit_signal("character_died")
			queue_free()

func _on_JumpTimer_timeout():
	full_jump = true


func _on_HookDelayTimer_timeout():
	hookshot_coolingdown = false


func _on_HookTravelTimer_timeout():
	using_hookshot = false
	movement.y = 0
#	can_jump = true
#	$GraceFallTimer.start()

#
#func _on_GraceFallTimer_timeout():
#	can_jump = false
