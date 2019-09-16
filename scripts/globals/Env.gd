extends Node

var character
var root
var scene_node

func _ready():
	root = get_tree().get_root()
	scene_node = root.get_child(root.get_child_count() - 1)
	character = _filter_characters(find_nodes_of_type(Character))

func get_character():
	return character

func find_nodes_of_type(type):
	var nodes = []
	
	for child in scene_node.get_children():
		if child is type:
			nodes.append(child)
			
	return nodes
	
func _filter_characters(characters):
	"""There can be multiple characters during the time he dies"""
	for character in characters:
		if character.get_name() == "Character": 
			return character