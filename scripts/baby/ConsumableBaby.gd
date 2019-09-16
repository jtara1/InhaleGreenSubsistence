extends "res://scripts/Consumable.gd" # extends KinematicBody2D

export(float) var growth_increment_for_multiplier = 1

onready var baby = $"../"


func devoured(heWhoDevours: Agent, modifiers: Dictionary = {"body_size": growth_increment_for_multiplier}):
	.devoured(heWhoDevours, modifiers)
	baby.die()
	
######################
# event listners
func _on_Baby_body_entered(body):
	if body == Env.get_character() and not baby.died:
		devoured(body)