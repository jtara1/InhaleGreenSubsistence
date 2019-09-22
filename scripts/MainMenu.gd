extends CanvasLayer

onready var Scene = get_node("/root/Scene")


func _on_Start_pressed():
	Scene.load_scene("Level1")

func _on_Quit_pressed():
	get_tree().quit()
