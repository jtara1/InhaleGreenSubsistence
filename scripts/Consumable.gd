extends Node
class_name Consumable


func devoured(agent: Agent, modifiers: Dictionary = {}):
	agent.consume(modifiers)
