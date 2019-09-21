extends Area2D # extends something else

export(float) var chance_to_cry = 0.50
export(float) var jump_height = -350

var velocity = Vector2()
var grounded = false
var died = false

func _ready():
	jump()
	$SlimeSprite/AnimationPlayer.connect("animation_finished", self, "_on_SlimSprite_animation_finished")
	
func _physics_process(delta):
	velocity += (gravity if not grounded else 0) * gravity_vec * delta
	position += velocity * delta

func jump():
	grounded = false
	velocity += Vector2(0, jump_height)

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
		velocity = Vector2.ZERO
		grounded = true


func _on_IdleTimer_timeout():
	if randf() <= chance_to_cry:
		$IdleAudioPlayer.play()
		jump()
