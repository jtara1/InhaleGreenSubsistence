extends Camera2D

export(float) var scaling = 0.2
export(Vector2) var max_zoom = Vector2(10, 10)

onready var Vector2f = get_node("/root/Vector2f")

onready var character = $"../"

var init_zoom = zoom
var target_zoom = init_zoom


func _ready():
	character.connect("body_size_changed", self, "_on_Character_body_size_changed")
	set_target_zoom(character.body_size)
	
func _physics_process(delta):
	zoom = Vector2f.lerp(zoom, target_zoom, delta)
	
func set_target_zoom(body_size):
	var desired_zoom = init_zoom + init_zoom * body_size * scaling 
	target_zoom = Vector2f.clamp_vector(desired_zoom, init_zoom, max_zoom)
	
func _on_Character_body_size_changed(new_body_size):
	set_target_zoom(new_body_size)
