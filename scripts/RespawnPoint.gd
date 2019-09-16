extends Node2D

const group_name = "RespawnPoint"

export(bool) var is_current_spawn_point = false

const CharacterNode = preload("res://game-objects/Character.tscn")

onready var Env = get_node("/root/Env")

onready var root = $"../"


func _ready():
	listen_to_character_dying_event()
	add_to_group(group_name)

func spawn_character():
	# clear the dying char name
	var dead_character = Env.get_character()
	dead_character.set_name("DeadCharacter")
	
	# create a new char & update its cache
	var character = CharacterNode.instance()
	Env.character = character
	
	# update the new char position & name
	character.position = $PointToSpawnAt.global_position
	character.set_name("Character")
	
	listen_to_character_dying_event() # reconnect
	
	root.add_child(character) # add to scene tree

func listen_to_character_dying_event():
	Env.get_character().connect("character_died", self, "_on_Character_character_died")
	
func disable_other_spawns():
	for spawner in get_tree().get_nodes_in_group(group_name):
		if spawner != self:
			spawner.is_current_spawn_point = false

func _on_Character_character_died():
	if is_current_spawn_point:
		spawn_character()

func _on_RespawnPoint_body_entered(body):
	if body is Character:
		is_current_spawn_point = true
		disable_other_spawns()

