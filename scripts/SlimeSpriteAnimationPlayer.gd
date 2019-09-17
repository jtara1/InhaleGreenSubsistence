extends AnimationPlayer

onready var parent = $"../../"


func play(anim_name: String = "", custom_blend: float = -1.0, custom_speed: float = 1.0, from_end: bool = false) -> void:
	if parent.get("is_dead") and parent.is_dead():
		stop()
		if anim_name == "death":
			.play(anim_name, custom_blend, custom_speed, from_end)
	else:
		.play(anim_name, custom_blend, custom_speed, from_end)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue("idle")
