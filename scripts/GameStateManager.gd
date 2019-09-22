extends Node
class_name GameStateManager

signal game_won

onready var Env = get_node("/root/Env")


func win_the_game():
	emit_signal("game_won")