extends "res://scripts/agent/Agent.gd" # extends KinematicBody2D

signal animation_finished

export(float) var gravity = 9.8
export(float) var speed = 300.0
export(float) var max_speed = 10000
export(float) var fast_fall = 300
export(float) var max_fall_speed = 300
export(float) var max_jump_horizontal_speed = 160
export(float) var scaling_smoothing = 1

func _ready():
	self.connect("consumed", self, "_agent_consumed")

func _physics_process(delta):
	$CharacterScaling.scale_size(delta)
	
####################
# methods

	
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
