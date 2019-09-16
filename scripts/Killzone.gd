extends Area2D

export(bool) var enable_sprite = true

onready var Agent = load("res://scripts/agent/Agent.gd")


func _ready():
	if not enable_sprite:
		$Sprite.visible = false
	else:
		$Sprite/AnimationPlayer.play("idle")

func _on_Killzone_body_entered(body):
	if body is Agent:
		body.die()
