extends Sprite


func _ready():
	if $AnimationPlayer:
		$AnimationPlayer.play("idle")
