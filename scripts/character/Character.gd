extends "res://scripts/agent/Agent.gd" # extends KinematicBody2D
class_name Character

signal character_died
signal body_size_changed
signal dashed

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
export(float) var dash_speed = 1200
export(int) var dashes_remaining = 3
export(float) var init_body_size_multiplier = -1 # let inherited value from Agent decide if -1

onready var Vector2f = get_node("/root/Vector2f")
onready var sprite = $SlimeSprite
onready var animator = $SlimeSprite/AnimationPlayer
onready var raycast = $RayCast2D
onready var hook_shot_particle = $HookShotParticles
onready var particle_material = ParticlesMaterial.new()

var movement = Vector2()
var full_jump = false
var friction = false
var raycast_direction
var sprite_direction = Vector2(1,0)
var using_hookshot = false
var hookshot_coolingdown = false
var dashing_coolingdown = false
var wall_clinging = false
var target = Vector2()
var user_input = Vector2()
var is_dashing = false
var connected_hookshot = false
var particle_destination = Vector2()

####################
# core
func _ready():
	connect("consumed", self, "_agent_consumed")
	animator.connect("animation_finished", self, "_on_SlimeSprite_animation_finished")
	
	if init_body_size_multiplier != -1:
		body_size = init_body_size_multiplier
		
	particle_material.scale = 8
	particle_material.angular_velocity = 10000
	particle_material.linear_accel = 20
	particle_material.radial_accel = 25
	hook_shot_particle.process_material = particle_material
		
	$CharacterScaling.set_body_scaling(body_size)

func _physics_process(delta):
	particle_material.scale = 8 * scale.x
	hook_shot_particle.process_material = particle_material
	if not is_dead():
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
# move
func move(delta):
	movement.y += gravity
	var user_input = user_input()

	friction = false
	if not is_dashing:
		if user_input.x == 1:
			run_right()
		elif user_input.x == -1:
			run_left()
		else:
			stopped_running()
	
	air_controls()
	dash()
	hook_shot()
	$HookShotParticles

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

####################
# jump
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
		hook_shot_particle.global_position = self.global_position + Vector2(4.6,12.6)
		animator.play("shoot", -1, 5)
		using_hookshot = true
		hookshot_coolingdown = true
		$HookTravelTimer.start()
		$HookDelayTimer.start()
		
		if raycast.is_colliding():
			target = raycast.get_collision_point()
			particle_destination = target
			connected_hookshot = true
		else:
			particle_destination = self.global_position + raycast_direction * scale
			
		hook_shot_particle.emitting = true
		
	hook_shot_particle.global_position = Vector2f.lerp(hook_shot_particle.global_position, particle_destination, 0.15)		
	if connected_hookshot:
		global_position = Vector2f.lerp(global_position, target, 0.15)

####################
# dash
func dash():
	if Input.is_action_just_pressed("dodge") and can_dash():
		dashes_remaining -= 1
		emit_signal("dashed", dashes_remaining)
		
		is_dashing = true
		var dash_direction = sprite_direction() * dash_speed
		movement = dash_direction
		$DashTime.start()
		
func can_dash():
	return $DashTime.time_left <= 0.025 and dashes_remaining > 0
	
func sprite_direction():
	sprite_direction = user_input()
	if sprite_direction == Vector2.ZERO:
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
	
func respawned(attributes):
	for key in attributes.keys():
		self.set(key, attributes[key])
	
	$CharacterScaling.set_body_scaling(body_size)

####################
# event listeners
func _agent_consumed(attributes_mutated):
	for attribute in attributes_mutated:
		match attribute:
			"body_size":
				emit_signal("body_size_changed", body_size)
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
	connected_hookshot = false
	hook_shot_particle.emitting = false
	movement.y = 0

func _on_DashTime_timeout():
	is_dashing = false
	movement.y = lerp(movement.y, 0, 0.6)
