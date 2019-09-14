extends Area2D
class_name Consumable

onready var Env = get_node("/root/Env")


func _physics_process(delta):
	if overlaps_body(Env.get_character()):

		devoured(Env.get_character())

func devoured(agent: Agent, modifiers: Dictionary = {}):
	print("devoured")
	agent.consume(modifiers)
