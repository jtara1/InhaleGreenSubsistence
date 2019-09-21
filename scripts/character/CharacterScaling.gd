extends Node

signal character_scaling_changed

export(float) var scaling_smoothing = 10
export(float) var scaling_difference = 1 # the threshold after which the distance between target & scale says "yea it's close enough & scaled"

onready var Vector2f = get_node("/root/Vector2f")

onready var character = $"../"
onready var init_scale = character.scale
onready var target_scale = init_scale

var changing_scaling = false


func _ready():
	character.connect("body_size_changed", self, "_on_Character_body_size_changed")

func scale_size(delta):
	if character.scale.distance_to(target_scale) >= scaling_difference:
		changing_scaling = true
		var new_scale = Vector2f.lerp(character.scale, target_scale, scaling_smoothing * delta)
	
		if new_scale != Vector2.ZERO:
			character.scale = new_scale
	
	elif changing_scaling:
		emit_signal("character_scaling_changed", character.scale) # emit once it finished scaling
		changing_scaling = false # avoid emitting every frame it isn't scaling

func set_body_scaling(scaling_multiplier):
	target_scale = init_scale * scaling_multiplier

func _on_Character_body_size_changed(new_body_size):
	set_body_scaling(new_body_size)