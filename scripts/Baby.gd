extends "Consumable.gd" # extends KinematicBody2D

export(float) var growth_increment_for_multiplier = 0.5


func _enter_tree():
	$Character.speed = 0
	$Character.set_collision_layer_bit(0, 0)
	$Character.set_collision_mask_bit(0, 0)

func devoured(heWhoDevours: Agent, modifiers: Dictionary = {"body_size": growth_increment_for_multiplier}):
	.devoured(heWhoDevours, modifiers)
	queue_free()

func _on_Baby_body_entered(body):
	if body == Env.get_character():
		devoured(body)
