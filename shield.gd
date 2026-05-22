extends Area2D

var hits: int = 0
const MAX_HITS: int = 50
var is_invincible: bool = false


func _ready() -> void:
	add_to_group("shield")
