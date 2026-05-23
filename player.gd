extends CharacterBody2D

signal health_depleted
signal damage_taken
signal life_gained

@export var speed: float = 300.0
@export var ship_rotation: float = 10.0
@export var friction: float = 0.8
@export var health: int = 5
@export var has_piercing_laser: bool = false
@export var has_extra_laser: bool = false


var laser_scene: PackedScene = preload('res://laser.tscn')
var shield_scene: PackedScene = preload('res://shield.tscn')
var is_invincible: bool = false


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector('left', 'right', 'up', 'down')
	
	if Input.is_action_pressed("left"):
		global_rotation_degrees -= ship_rotation
	elif Input.is_action_pressed("right"):
		global_rotation_degrees += ship_rotation
	elif Input.is_action_pressed("up") or Input.is_action_pressed("down"):	
		velocity += direction.rotated(deg_to_rad(global_rotation_degrees)) * speed
	
	var forward = -transform.y
	var dot = velocity.dot(forward)
	if dot < 0:
		velocity -= forward * dot

	velocity *= friction
	move_and_slide()
	%ThrustParticles.emitting = Input.is_action_pressed("up")
	%ThrustParticles.angle_min = -global_rotation_degrees
	%ThrustParticles.angle_max = -global_rotation_degrees

	#if is_invincible:
		#$Sprite2D.visible = int(Time.get_ticks_msec() / 100) % 2 == 0
	#else:
		#$Sprite2D.visible = true

	if is_invincible:
		$Sprite2D.modulate.a = 0.5 + 0.5 * sin(Time.get_ticks_msec() * 0.01)
	else:
		$Sprite2D.modulate.a = 1.0

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
		var points := [%LaserSpawnPoint]
		if has_extra_laser:
			points.append(%LaserSpawnPoint2)
		for spawn_point in points:
			var laser: Node2D = laser_scene.instantiate()
			if has_piercing_laser:
				laser.set_is_piercing(true)
			laser.global_rotation = spawn_point.global_rotation
			laser.global_position = spawn_point.global_position
			spawn_point.add_child(laser)
		

func take_damage() -> void:
	if is_invincible:
		return
	health -= 1
	print('health ' + str(health))
	is_invincible = true
	velocity = Vector2.ZERO
	get_tree().create_timer(1.5).timeout.connect(func(): is_invincible = false)
	global_position = get_viewport_rect().size / 2
	damage_taken.emit()
	if health <= 0:
		health_depleted.emit()
	

func gain_life() -> void:
	health += 1
	print('GAINING A LIFE ' + str(health))
	life_gained.emit()


func gain_extra_laser() -> void:
	has_extra_laser = true
	%LaserSpawnPoint.position = Vector2(-20, -96)
	%LaserSpawnPoint2.position = Vector2(20, -96)


func gain_shield() -> void:
	var shield: Area2D = shield_scene.instantiate()
	call_deferred('add_child', shield)	


func set_has_piercing_laser(val: bool) -> void:
	has_piercing_laser = val
