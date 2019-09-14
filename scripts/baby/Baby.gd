extends Area2D # extends something else

var died = false

func _ready():
	$SlimeSprite/AnimationPlayer.connect("animation_finished", self, "_on_SlimSprite_animation_finished")

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
