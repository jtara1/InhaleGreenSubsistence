extends Area2D

onready var Agent = load("res://scripts/agent/Agent.gd")


func _on_Killzone_body_entered(body):
	if body is Agent:
		body.die()
