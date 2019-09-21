extends Control

onready var Env = get_node("/root/Env")

onready var size_label = $CenterContainer/VBoxContainer/SizeLabel
onready var dashes_label = $CenterContainer/VBoxContainer/DashesLabel


func _ready():
	Env.get_character().connect("dashed", self, "_on_Character_dashed")
	Env.connect("character_respawned", self, "_on_Character_character_respawned")
	
	_on_Character_dashed(Env.get_character().dashes_remaining) # init value

func _on_Character_character_respawned(character):
	character.connect("dashed", self, "_on_Character_dashed")
	
func _on_Character_dashed(remaining):
	dashes_label.text = "Dashes: " + str(remaining)