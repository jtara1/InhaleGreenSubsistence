extends KinematicBody2D
class_name Agent

signal consumed

var health: int = 10
var body_size: float = 1.0 # multiplier to scale the actual size
var dead = false

func consume(modifiers: Dictionary):
	for key in modifiers.keys():
		var value = self.get(key)
		self.set(key, value + modifiers[key])
		
	emit_signal("consumed", modifiers.keys()) # this could just be override in inheritance, but someone else might want to listen
	
func die():
	dead = true
	
func is_dead():
	return dead