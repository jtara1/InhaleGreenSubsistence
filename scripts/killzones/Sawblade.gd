extends "res://scripts/killzones/Killzone.gd"

onready var Vector2f = get_node("/root/Vector2f")

onready var init_position = global_position


func _physics_process(delta):
	position = init_position + $Path2D/PathFollow2D.position * 10
