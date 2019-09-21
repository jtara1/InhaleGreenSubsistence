extends "res://scripts/GameObject.gd" # extends Area2D


func break_self():
	if not died:
		die()
		$AnimatedSprite.playing = true
		$AudioStreamPlayer2D.playing = true

func _on_BreakableBox_body_entered(body):
	if body is Agent:
		break_self()

func _on_AnimatedSprite_animation_finished():
	queue_free()
