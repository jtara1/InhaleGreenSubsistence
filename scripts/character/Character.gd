extends "res://scripts/agent/Agent.gd" # extends KinematicBody2D

signal animation_finished

export(float) var speed = 300.0


func _ready():
	self.connect("consumed", self, "_agent_consumed")

func _physics_process(delta):
	move(delta)
	$CharacterScaling.scale_size(delta)
	
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
