extends Area2D

var hits: int = 0
const MAX_HITS: int = 5
var is_invincible: bool = false


func _ready() -> void:
	add_to_group("shield")


func take_hit() -> void:
	hits += 1
	print('shield hit ' + str(hits) + '/' + str(MAX_HITS))
	if hits >= MAX_HITS:
		queue_free()
