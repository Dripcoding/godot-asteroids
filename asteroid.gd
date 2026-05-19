extends Area2D


signal asteroid_hit


@export var health: int = 3
@export var sizes: Array[String] = ['big', 'med', 'small', 'tiny']
@export var current_size: String = 'big'
@export var color: String = 'Grey'
@export var min_speed: float = 300.0
@export var max_speed: float = 500.0


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
			
			
func update_stats() -> void:
	health -= 1
	if (health >= 0): 
		current_size = sizes[3 - health]
		asteroid_hit.emit(self)
	else:
		self.queue_free()
		
		
func update_texture() -> void:
	$Sprite2D.texture = load("res://PNG/Meteors/meteor%s_%s1.png" % [color, current_size])
