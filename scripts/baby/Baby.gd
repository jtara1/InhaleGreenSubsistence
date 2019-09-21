extends "res://scripts/GameObject.gd" # extends Area2D

export(float) var chance_to_cry = 0.50


func _ready():
	._ready() # connects body_entered signal to self
	jump()
	$SlimeSprite/AnimationPlayer.connect("animation_finished", self, "_on_SlimSprite_animation_finished")

func die():
	.die() # died = true
	$AudioStreamPlayer2D.play()
	$SlimeSprite/AnimationPlayer.play("death")

######################
# event listners
func _on_SlimSprite_animation_finished(anim_name):
	match anim_name:
		"death":
			queue_free()

func _on_IdleTimer_timeout():
	if randf() <= chance_to_cry:
		$IdleAudioPlayer.play()
		jump()
