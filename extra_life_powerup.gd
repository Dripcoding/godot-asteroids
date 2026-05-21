extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print('picked up extra life')
	if (body.has_method('gain_life')):
		body.gain_life()
