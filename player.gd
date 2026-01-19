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
