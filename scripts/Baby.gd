extends "Consumable.gd" # extends KinematicBody2D


func _enter_tree():
	$Character.speed = 0

func devoured(agent: Agent, modifiers: Dictionary = {"size": 1.0}):
	.devoured(agent, modifiers)