extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print('PICKED UP SHIELD POWERUP')
	if (body.has_method('gain_shield')):
		body.gain_shield()
	queue_free()
