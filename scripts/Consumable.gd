extends Area2D
class_name Consumable

onready var Env = get_node("/root/Env")


func devoured(agent: Agent, modifiers: Dictionary = {}):
	print("devoured")
	agent.consume(modifiers)
