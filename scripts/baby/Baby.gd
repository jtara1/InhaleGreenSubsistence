extends Area2D # extends something else

var died = false


func die():
	died = true
	$AudioStreamPlayer2D.play()
	$SlimeSprite/AnimationPlayer.play("death")

######################
# event listners
func _on_Character_animation_finished(anim_name):
	match anim_name:
		"death":
			queue_free()
