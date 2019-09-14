extends CollisionShape2D # this could be a problem later down the line where you end up making NodeConsumable, CollisionShape2DConsumable, etc clases which is probably an anti-pattern in OOP
class_name Consumable

onready var Env = get_node("/root/Env")


func devoured(agent: Agent, modifiers: Dictionary = {}):
	agent.consume(modifiers)
