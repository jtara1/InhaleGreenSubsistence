extends Node

var character


func _ready():
	character = get_node("/root/Main/Character")

func get_character():
	return character
	
func find_nodes_of_type(type):
	for node in get_tree().children:
		pass