extends Area2D # extends something else

var velocity = Vector2()
var grounded = false
var died = false


func _ready():
	$SlimeSprite/AnimationPlayer.connect("animation_finished", self, "_on_SlimSprite_animation_finished")
	
func _physics_process(delta):
	if not grounded:
		velocity += gravity * gravity_vec * delta
		position += velocity * delta

func die():
	died = true
	$AudioStreamPlayer2D.play()
	$SlimeSprite/AnimationPlayer.play("death")

######################
# event listners
func _on_SlimSprite_animation_finished(anim_name):
	match anim_name:
		"death":
			queue_free()


func _on_Baby_body_entered(body):
	if body is TileMap:
		grounded = true
