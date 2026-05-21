extends Timer


@export var current_powerup: String = ''
@export var powerup_pos_offset: float = 50.0


@onready var powerups = {
	'extra_life': preload('res://extra_life_powerup.tscn'),
	'shield': preload('res://PNG/Power-ups/powerupYellow_shield.png'),
	'piercing_laser': preload('res://PNG/Lasers/laserGreen01.png')
}


var rng = RandomNumberGenerator.new()
var viewport_size: Vector2i = DisplayServer.window_get_size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_timeout() -> void:
	_spawn_powerup()
	
	
func _determine_powerup_position() -> Vector2:
	var position_x: float = rng.randf_range(powerup_pos_offset, viewport_size.x - powerup_pos_offset)
	var position_y: float = rng.randf_range(powerup_pos_offset, viewport_size.y - powerup_pos_offset)
	
	return Vector2(position_x, position_y)

func _spawn_powerup() -> void:
	print('SPAWNING POWERUP')
	var powerup = powerups['extra_life'].instantiate()
	powerup.global_position = _determine_powerup_position()
	add_child(powerup)
	
