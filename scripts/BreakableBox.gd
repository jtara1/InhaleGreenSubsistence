extends "res://scripts/GameObject.gd" # extends Area2D

export(int) var size_needed_to_break = 2

	
func break_self():
	if not died:
		$KinematicBody2D.queue_free()
		die()
		$AnimatedSprite.playing = true
		$AudioStreamPlayer2D.playing = true

func _on_BreakableBox_body_entered(body):
	if body is Agent:
		if body.body_size >= size_needed_to_break:
			break_self()

func _on_AnimatedSprite_animation_finished():
	queue_free()
