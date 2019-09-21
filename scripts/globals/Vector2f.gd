extends Node


func lerp(vector1: Vector2, vector2: Vector2, time: float):
	var x = lerp(vector1.x, vector2.x, time)
	var y = lerp(vector1.y, vector2.y, time)
	
	return Vector2(x, y)

func clamp_vector(vector: Vector2, min_vector: Vector2, max_vector: Vector2):
	var x = clamp(vector.x, min_vector.x, max_vector.x)
	var y = clamp(vector.y, min_vector.y, max_vector.y)
	
	return Vector2(x, y)