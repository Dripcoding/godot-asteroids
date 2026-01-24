extends CharacterBody2D

signal health_depleted

@export var speed: float = 300.0
@export var ship_rotation: float = 10.0
@export var friction: float = 0.8
@export var health: int = 5


var laser_scene: PackedScene = preload('res://laser.tscn')


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector('left', 'right', 'up', 'down')
	
	if Input.is_action_pressed("left"):
		global_rotation_degrees -= ship_rotation
	elif Input.is_action_pressed("right"):
		global_rotation_degrees += ship_rotation
	elif Input.is_action_pressed("up") or Input.is_action_pressed("down"):	
		velocity += direction.rotated(deg_to_rad(global_rotation_degrees)) * speed
	
	velocity *= friction
	move_and_slide()

	shoot()


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
		
		
func shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		var laser: Node2D = laser_scene.instantiate()
		laser.global_rotation = %LaserSpawnPoint.global_rotation
		laser.global_position = %LaserSpawnPoint.global_position
		%LaserSpawnPoint.add_child(laser)
		

func take_damage() -> void:
	print('taking damage from asteroid')
	health -= 1
	print('health ' + str(health))
	if health <= 0:
		health_depleted.emit()
	
