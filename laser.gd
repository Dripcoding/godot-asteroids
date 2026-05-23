extends Area2D


@export var speed: float = 500.0
var is_piercing: bool = false


func _ready() -> void:
	%VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)


func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(global_rotation) * speed * delta


func destroy() -> void:
	queue_free()


func _on_screen_exited() -> void:
	destroy()
	
func set_is_piercing(val: bool) -> void:
	is_piercing = val
