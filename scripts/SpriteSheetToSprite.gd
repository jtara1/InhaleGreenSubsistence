extends Node

export(int) var width = 32
export(int) var height = 32

onready var sprite = $"../"
onready var image_size = sprite.texture.get_size()
onready var frames_per_animation = int(image_size.x / width) - 1 # 0-indexed
onready var total_animations = int(image_size.y / height) - 1

const animations = []


func _ready():
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, width, height)

func _build_animations():
	for i in total_animations:
		var meta = {}
		var frames = []
		
		for j in frames_per_animation:
			frames.append(Rect2

func play_animation(index, loop = true):
#	sprite.region_rect = Rect2(index * 
	pass