extends Area2D


@export var speed: float = 300.0


func _ready() -> void:
	add_to_group('lasers')	


func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(global_rotation) * speed * delta
