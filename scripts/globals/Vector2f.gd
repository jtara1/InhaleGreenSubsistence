extends Node


func lerp(vector1: Vector2, vector2: Vector2, time: float):
	var x = lerp(vector1.x, vector2.x, time)
	var y = lerp(vector1.y, vector2.y, time)
	
	return Vector2(x, y)
