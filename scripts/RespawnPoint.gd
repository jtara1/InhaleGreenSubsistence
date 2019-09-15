extends Node2D

const Character = preload("res://game-objects/Character.tscn")

onready var Env = get_node("/root/Env")

onready var root = $"../"


func _ready():
	listen_to_character_dying_event()

func spawn_character():
	var dead_character = Env.get_character()
	dead_character.set_name("DeadCharacter")
	
	var character = Character.instance()
	Env.character = character
	
	character.position = position
	character.set_name("Character")
	
	listen_to_character_dying_event() # reconnect
	
	root.add_child(character)

func listen_to_character_dying_event():
	Env.get_character().connect("character_died", self, "_on_Character_character_died")

func _on_Character_character_died():
	spawn_character()
