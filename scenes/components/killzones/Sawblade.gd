extends "res://scripts/Killzone.gd"

# Declare member variables here. Examples:
export (float) var speed = 30

var original_position = Vector2()
var target_point = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = self.global_position
	target_point = $Target.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position += global_position.direction_to(target_point) * speed
	if self.global_position == target_point:
		target_point = original_position
		#original_position = 
