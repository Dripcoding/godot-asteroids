extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("PICKED UP EXTRA LASER POWER UP")
	if (body.has_method("gain_extra_laser")):
		body.gain_extra_laser()
	queue_free()
