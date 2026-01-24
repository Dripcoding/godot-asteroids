extends Area2D


@export var health: int = 3


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('take_damage'):
		body.take_damage()
