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
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	speed = rng.randf_range(min_speed, max_speed)
	velocity = Vector2.from_angle(randf() * TAU)
	update_texture()


func _physics_process(delta: float) -> void:
	position += velocity * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('take_damage'):
		body.take_damage()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('lasers'):
		area.destroy()
		update_stats()
			
			
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
			
func update_stats() -> void:
	health -= 1
	if (health >= 0):
		current_size = sizes[3 - health]
		if current_size != 'tiny':
			spawn_children()
	queue_free()


func update_texture() -> void:
	$Sprite2D.texture = load("res://PNG/Meteors/meteor%s_%s1.png" % [color, current_size])


func spawn_children() -> void:
	for i in range(2):
		var child = asteroid_scene.instantiate()
		child.global_position = global_position
		child.current_size = current_size
		child.color = color
		child.health = 3 - sizes.find(current_size)
		get_parent().add_child(child)
