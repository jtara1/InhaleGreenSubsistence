extends Node

signal character_respawned

var character # private attribute
var root
var scene_node


func _ready():
	root = get_tree().get_root()
	init()
	
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
	# character is null pointer / dangling pointer or null, re-init
	if character == null or not weakref(character).get_ref():
		init() # re-init (scene changed)
		
	return character
	
func set_character(character):
	self.character = character
	emit_signal("character_respawned", character) # listeners won't have a ref to this new instance yet

func _filter_characters(characters):
	"""There can be multiple characters during the time he dies"""
	for character in characters:
		if character.get_name() == "Character": 
			return character

##################
# util
func find_nodes_of_type(type, return_first = false):
	var nodes = []
	
	for child in scene_node.get_children():
		if child is type:
			if return_first:
				return child
			nodes.append(child)
			
	return nodes if not return_first else null

func find_node_of_type(type):
	return find_nodes_of_type(type, true)
	
func create_timer(parent_of_timer: Node, duration = 1.0, one_shot = true, autostart = true):
	var timer = Timer.new()
	
	timer.wait_time = duration
	timer.one_shot = one_shot
	timer.autostart = autostart  # this timer never enters the scene tree so autostart attr has no effect
	
	parent_of_timer.add_child(timer)
	
	if autostart:
		timer.start()
	
	return timer