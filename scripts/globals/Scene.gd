extends Node

signal scene_changed

const Paths = {
	"MainMenu": "res://scenes/menus/MainMenu.tscn", 
	"Overworld": "res://scenes/Overworld.tscn",
	"Lv0": "res://scenes/Level1.tscn", 
	"Lv1": "res://scenes/Lv1.tscn", 
	"Lv2": "res://scenes/Lv2.tscn",
	"Lv3": "res://scenes/Lv3.tscn",
}

func load_scene(scene):
	get_tree().change_scene(Paths[scene])
	emit_signal("scene_changed", scene)