extends CanvasLayer

onready var Scene = get_node("/root/Scene")


func _on_Start_pressed():
	Scene.load_scene("Overworld")

func _on_About_pressed():
	$WindowDialog.popup_centered_ratio(0.8)
	
func _on_Quit_pressed():
	get_tree().quit()

func _on_Credits_pressed():
	$CreditsDialog.popup_centered_ratio(0.8)
