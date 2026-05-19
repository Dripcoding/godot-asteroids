extends Area2D


signal asteroid_hit


@export var health: int = 3
@export var sizes: Array[String] = ['big', 'med', 'small', 'tiny']
@export var current_size: String = 'big'
@export var color: String = 'Grey'


func _ready() -> void:
	update_texture()


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
