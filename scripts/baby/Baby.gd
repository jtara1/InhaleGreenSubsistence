extends "res://scripts/Consumable.gd" # extends KinematicBody2D

export(float) var growth_increment_for_multiplier = 0.5

var died = false

func _enter_tree():
	$Character.speed = 0
	$Character.set_collision_layer_bit(0, 0)
	$Character.set_collision_mask_bit(0, 0)

func devoured(heWhoDevours: Agent, modifiers: Dictionary = {"body_size": growth_increment_for_multiplier}):
	.devoured(heWhoDevours, modifiers)
	die()

func die():
	died = true
	$AudioStreamPlayer2D.play()
	$Character/AnimationPlayer.play("death")

######################
# event listners
func _on_Baby_body_entered(body):
	if body == Env.get_character() and not died:
		devoured(body)

func _on_Character_animation_finished(anim_name):
	match anim_name:
		"death":
			queue_free()
