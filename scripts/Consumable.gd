extends Node
class_name Consumable

var agent_attrs_to_modify = {}


func devoured(agent: Agent, modifiers: Dictionary = {}):
	agent.consume(modifiers)
