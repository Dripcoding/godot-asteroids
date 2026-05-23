extends Area2D


const sizes: Array[String] = ['big', 'med', 'small', 'tiny']
const MAX_HEALTH: int = 3
const SHIELD_SPAWN_BUFFER: float = 20.0
const SHIELD_DEFLECT_SPREAD_DEG: float = 30.0
const SPLIT_COUNT: int = 2


@export var health: int = MAX_HEALTH
@export var current_size: String = 'big'
@export var color: String = 'Grey'
@export var min_speed: float = 300.0
@export var max_speed: float = 500.0


var asteroid_scene: PackedScene = preload('res://asteroid.tscn')
var speed: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var is_hit: bool = false
var ignored_laser: Area2D = null
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	speed = rng.randf_range(min_speed, max_speed)
	if velocity == Vector2.ZERO:
		velocity = Vector2.from_angle(rng.randf() * TAU)
	update_texture()


func _physics_process(delta: float) -> void:
	position += velocity * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('take_damage') and not body.get('is_invincible'):
		body.take_damage()
		update_stats()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('lasers'):
		if area == ignored_laser:
			return
		if not area.is_piercing:
			area.queue_free()
		update_stats(area if area.is_piercing else null)
	elif area.is_in_group('shield'):
		area.take_hit()
		update_stats(null, area)
			
			
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	var viewport_rect: Rect2 = get_viewport_rect()
	# wrap around x axis from left to right
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
	# asteroid already hit so debounce to avoid double collision
	if is_hit:
		return
	# continue with spawning smaller asteroids if asteroid wasn't already hit
	is_hit = true
	health -= 1
	if health >= 0:
		current_size = sizes[MAX_HEALTH - health]
		if current_size != sizes.back():
			spawn_children(area, shield)
	# free asteroid that was hit
	queue_free()


func update_texture() -> void:
	$Sprite2D.texture = load("res://PNG/Meteors/meteor%s_%s1.png" % [color, current_size])


func spawn_children(laser: Area2D = null, shield: Area2D = null) -> void:
	var outward_dir: Vector2 = Vector2.ZERO
	var spawn_offset: float = 0.0
	
	# handle collision with shield
	# child asteroids should be deflected normal to shields position
	if shield != null:
		outward_dir = (global_position - shield.global_position).normalized()
		var child_radius: float = ($CollisionShape2D.shape as CircleShape2D).radius
		spawn_offset = shield.collision_radius + child_radius + SHIELD_SPAWN_BUFFER

	# draw child asteroids
	for i in range(SPLIT_COUNT):
		var child: Node2D = asteroid_scene.instantiate()
		child.global_position = global_position
		child.current_size = current_size
		child.color = color
		child.health = MAX_HEALTH - sizes.find(current_size)
		child.ignored_laser = laser
		
		if shield != null:
			var spread: float = deg_to_rad(SHIELD_DEFLECT_SPREAD_DEG) * (1.0 if i == 0 else -1.0)
			var dir: Vector2 = outward_dir.rotated(spread)
			child.global_position = shield.global_position + dir * spawn_offset
			child.velocity = dir

		# defer adding child until the next idle cycle
		# physics can't be changed for asteroid until physics requests
		# are processed in the current cycle (all requests are locked)
		get_parent().call_deferred("add_child", child)
