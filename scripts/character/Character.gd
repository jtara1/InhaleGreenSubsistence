extends "res://scripts/agent/Agent.gd" # extends KinematicBody2D

export(float) var speed = 300.0
export(float) var scaling_smoothing = 10

onready var init_sprite_scale = $Sprite.scale
onready var init_hurtbox_scale = $CollisionShape2D.scale

onready var target_sprite_scale = init_sprite_scale
onready var target_hurtbox_scale = init_hurtbox_scale


func _ready():
	self.connect("consumed", self, "_agent_consumed")

func _physics_process(delta):
	move(delta)
	scale_size(delta)
	
####################
# methods
func move(delta):
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
	
func scale_size(delta):
	var sprite_scale = $Sprite.scale.slerp(target_sprite_scale, scaling_smoothing * delta)
	var hbox_scale = $CollisionShape2D.scale.slerp(target_hurtbox_scale, scaling_smoothing * delta)
	
	if sprite_scale != Vector2.ZERO:
		print(sprite_scale, hbox_scale)
		$Sprite.scale += sprite_scale
		$CollisionShape2D.scale += hbox_scale
	

func set_body_scaling(scaling_multiplier):
	target_sprite_scale = $Sprite.scale * scaling_multiplier
	target_hurtbox_scale = $CollisionShape2D.scale * scaling_multiplier
	
####################
# event listeners
func _agent_consumed(attributes_mutated):
	for attribute in attributes_mutated:
		match attribute:
			"body_size":
				set_body_scaling(self.body_size)
			"health":
				pass # TODO: emit health changed signal for some UI 