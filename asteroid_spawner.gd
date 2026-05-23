extends Timer


const SPAWN_EDGE_OFFSET: float = 50.0


var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var asteroid_scene: PackedScene = preload('res://asteroid.tscn')
var viewport_size: Vector2i = DisplayServer.window_get_size()


func _on_timeout() -> void:
	start_spawning()


func start_spawning() -> void:
	var new_asteroid = asteroid_scene.instantiate()
	new_asteroid.global_position = _get_random_edge_position()
	get_parent().add_child(new_asteroid)
	
	
func _get_random_edge_position() -> Vector2:
	var sides: Array[String] = ['top', 'right', 'left', 'bottom'] 
	var side: String = sides.pick_random()
	
	match side:
		'top': return Vector2(rng.randf_range(0, viewport_size.x), -SPAWN_EDGE_OFFSET)
		'right': return Vector2(viewport_size.x + SPAWN_EDGE_OFFSET, rng.randf_range(0, viewport_size.y))
		'left': return Vector2(-SPAWN_EDGE_OFFSET, rng.randf_range(0, viewport_size.y))
		_: return Vector2(rng.randf_range(0, viewport_size.x), viewport_size.y + 50)
	
