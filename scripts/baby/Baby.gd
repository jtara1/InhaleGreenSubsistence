extends Area2D # extends something else

var died = false

func _enter_tree():
	$Character.speed = 0
	$Character.set_collision_layer_bit(0, 0)
	$Character.set_collision_mask_bit(0, 0)

func die():
	died = true
	$AudioStreamPlayer2D.play()
	$Character/AnimationPlayer.play("death")

######################
# event listners
func _on_Character_animation_finished(anim_name):
	match anim_name:
		"death":
			queue_free()
