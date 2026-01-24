extends Area2D


@export var health: int = 3


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('take_damage'):
		body.take_damage()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('lasers'):
		health -= 1
		print('health ' + str(health))
		#area.queue_free()
