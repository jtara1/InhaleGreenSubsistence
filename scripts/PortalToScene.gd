extends Area2D

export(String) var scene_to_load = "Level1"

onready var Scene = get_node("/root/Scene")


func _ready():
	$Label.text = scene_to_load

func _on_PortalToScene_body_entered(body):
	if body is Agent:
		Scene.load_scene(scene_to_load)
