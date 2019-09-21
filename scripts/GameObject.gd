extends Area2D
class_name GameObject

export(float) var jump_height = -350

var velocity = Vector2()
var grounded = false
var died = false


func _ready():
	connect("body_entered", self, "_on_GameObject_body_entered")

func _physics_process(delta):
	velocity += (gravity if not grounded else 0) * gravity_vec * delta
	position += velocity * delta

func jump():
	grounded = false
	velocity += Vector2(0, jump_height)

func die():
	died = true
	
###################
# event listeners
func _on_GameObject_body_entered(body):
	if body is TileMap:
		velocity = Vector2.ZERO
		grounded = true