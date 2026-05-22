extends Area2D


@export var health: int = 3
@export var sizes: Array[String] = ['big', 'med', 'small', 'tiny']
@export var current_size: String = 'big'
@export var color: String = 'Grey'
@export var min_speed: float = 300.0
@export var max_speed: float = 500.0

var asteroid_scene: PackedScene = preload('res://asteroid.tscn')
var speed: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var is_hit: bool = false
var ignored_laser: Area2D = null
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	add_to_group("asteroids")
	speed = rng.randf_range(min_speed, max_speed)
	if velocity == Vector2.ZERO:
		velocity = Vector2.from_angle(randf() * TAU)
	update_texture()


func _physics_process(delta: float) -> void:
	position += velocity * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('take_damage') and not body.get('is_invincible'):
		body.take_damage()
		update_stats()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('lasers') and !area.is_piercing:
		area.destroy()
		update_stats()
	elif area.is_in_group('lasers') and area.is_piercing:
		if area == ignored_laser:
			return
		update_stats(area)
	elif area.is_in_group('shield'):
		area.take_hit()
		update_stats(null, area)
			
			
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
			
func update_stats(area: Area2D = null, shield: Area2D = null) -> void:
	if is_hit:
		return
	is_hit = true
	health -= 1
	if (health >= 0):
		current_size = sizes[3 - health]
		if current_size != 'tiny':
			spawn_children(area, shield)
	queue_free()


func update_texture() -> void:
	$Sprite2D.texture = load("res://PNG/Meteors/meteor%s_%s1.png" % [color, current_size])


func spawn_children(area: Area2D = null, shield: Area2D = null) -> void:
	var outward_dir: Vector2 = Vector2.ZERO
	var spawn_offset: float = 0.0
	if shield != null:
		outward_dir = (global_position - shield.global_position).normalized()
		if outward_dir == Vector2.ZERO:
			outward_dir = Vector2.from_angle(randf() * TAU)
		var shield_shape: CircleShape2D = shield.get_node("CollisionShape2D").shape
		var child_shape: CircleShape2D = $CollisionShape2D.shape
		spawn_offset = shield_shape.radius + child_shape.radius + 20.0

	for i in range(2):
		var child = asteroid_scene.instantiate()
		child.global_position = global_position
		child.current_size = current_size
		child.color = color
		child.health = 3 - sizes.find(current_size)
		child.ignored_laser = area
		if shield != null:
			var spread: float = deg_to_rad(30.0) * (1.0 if i == 0 else -1.0)
			var dir: Vector2 = outward_dir.rotated(spread)
			child.global_position = shield.global_position + dir * spawn_offset
			child.velocity = dir

		get_parent().call_deferred("add_child", child)
