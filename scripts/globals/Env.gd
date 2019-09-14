extends Node

var character


func _ready():
	character = get_node("/root/Main/Character")

func get_character():
	return character