extends Node
class_name Agent

var health: int = 10
var body_size: float = 10.0

func consume(modifiers: Dictionary):
	for key in modifiers.keys():
		var value = self.get(key)
		self.set(key, value + modifiers[key])