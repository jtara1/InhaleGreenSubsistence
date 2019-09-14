extends "Consumable.gd" # extends KinematicBody2D


func _enter_tree():
	$Character.speed = 0
	$Character.set_collision_layer_bit(0, 0)
	$Character.set_collision_mask_bit(0, 0)

func devoured(agent: Agent, modifiers: Dictionary = {"body_size": 1.0}):
	.devoured(agent, modifiers)
	queue_free()

func _on_Baby_body_entered(body):
	if body == Env.get_character():
		devoured(body)
