extends Node
class_name GameStateManager

signal game_won

onready var Env = get_node("/root/Env")


func win_the_game():
	emit_signal("game_won")
	Env.create_timer(self, 5).connect("timeout", self, "_on_Timer_timeout") 
	
func _on_Timer_timeout():
		Scene.load_scene("Overworld")