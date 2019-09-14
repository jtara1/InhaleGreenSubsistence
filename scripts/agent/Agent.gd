extends KinematicBody2D
class_name Agent

signal consumed

var health: int = 10
var body_size: float = 1.0 # multiplier to scale the actual size

func consume(modifiers: Dictionary):
	for key in modifiers.keys():
		var value = self.get(key)
		self.set(key, value + modifiers[key])
		
	emit_signal("consumed", modifiers.keys()) # thi	s could just be override in inheritance, but someone else might want to listen
	
func die():
	print_debug("not implemented")