extends Area2D


@export var speed: float = 300.0


func _ready() -> void:
	add_to_group('lasers')
	%VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)


func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(global_rotation) * speed * delta


func destroy() -> void:
	queue_free()


func _on_screen_exited() -> void:
	destroy()
