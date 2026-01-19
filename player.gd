extends CharacterBody2D


@export var speed: float = 300.0
@export var ship_rotation: float = 7.0
@export var friction: float = 0.8


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector('left', 'right', 'up', 'down')
	velocity += direction * speed
	velocity *= friction
	move_and_slide()
	
	if Input.is_action_pressed("left"):
		global_rotation_degrees -= ship_rotation
	elif Input.is_action_pressed("right"):
		global_rotation_degrees += ship_rotation


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	var viewport_rect: Rect2 = get_viewport_rect()
#	# wrap around x axis from left to right
	if global_position.x < viewport_rect.position.x:
		global_position.x = viewport_rect.end.x
	# wrap around x axis from right to left
	elif global_position.x > viewport_rect.end.x:
		global_position.x = viewport_rect.position.x
	
	# wrap around y axis from top to bottom
	if global_position.y < viewport_rect.position.y:
		global_position.y = viewport_rect.end.y
	# wrap around y axis from bottom to top
	elif global_position.y > viewport_rect.end.y:
		global_position.y = viewport_rect.position.y
