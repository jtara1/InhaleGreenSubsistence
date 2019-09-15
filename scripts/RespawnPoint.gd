extends Node2D

const Character = preload("res://game-objects/Character.tscn")

onready var Env = get_node("/root/Env")

onready var root = $"../"


func spawn_character():
	var dead_character = Env.get_character()
	dead_character.set_name("DeadCharacter")
	
	var character = Character.instance()
	Env.character = character
	
	character.position = position
	character.set_name("Character")
	
	root.add_child(character)

func _on_Character_character_died():
	spawn_character()
