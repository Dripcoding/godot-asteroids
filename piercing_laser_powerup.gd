extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if (body.has_method('set_has_piercing_laser')):
		body.set_has_piercing_laser(true)
	queue_free()
	
