extends Timer


var rng = RandomNumberGenerator.new()
var asteroid_scene: PackedScene = preload('res://asteroid.tscn')
var viewport_size: Vector2i = DisplayServer.window_get_size()


func _on_timeout() -> void:
	print('spawning asteroid')
	start_spawning()


func start_spawning() -> void:
	var new_asteroid = asteroid_scene.instantiate()
	new_asteroid.global_position = _get_random_edge_position()
	get_parent().add_child(new_asteroid)
	
	
func stop_spawning() -> void:
	%AsteroidSpawner.stop()
	
	
func _get_random_edge_position() -> Vector2:
	var sides: Array[String] = ['top', 'right', 'left', 'bottom'] 
	var side: String = sides[rng.randi_range(0, sides.size() - 1)]
	
	match side:
		'top': return Vector2(rng.randf_range(0, viewport_size.x), -50)
		'right': return Vector2(viewport_size.x + 50, rng.randf_range(0, viewport_size.y))
		'left': return Vector2(-50, rng.randf_range(0, viewport_size.y))
		_: return Vector2(rng.randf_range(0, viewport_size.x), viewport_size.y + 50)
	
