extends Node

signal character_respawned

var character # private attribute
var root
var scene_node


func _ready():
	root = get_tree().get_root()	
	init()
#	scene_node.connect("tree_exited", self, "wait_for_scene_node_to_enter_tree")
	
func init():
	update_scene_node()
	update_character()
	return character

func update_scene_node():
	scene_node = root.get_child(root.get_child_count() - 1)

##################
# character
func find_character():
	return _filter_characters(find_nodes_of_type(Character))

func update_character():
	character = find_character()

func get_character(): # cached
	return character if character != null else init()
	
func set_character(character):
	self.character = character
	emit_signal("character_respawned", character) # global since the listeners won't have a ref to this new instance yet

func _filter_characters(characters):
	"""There can be multiple characters during the time he dies"""
	for character in characters:
		if character.get_name() == "Character": 
			return character

##################
# util
func find_nodes_of_type(type):
	var nodes = []
	
	for child in scene_node.get_children():
		if child is type:
			nodes.append(child)
			
	return nodes
