extends Node2D


var ship_scene: CompressedTexture2D = preload('res://PNG/playerShip2_red.png')


func _ready() -> void:
	for i in range(%Player.health, 0, -1):
		var ship_icon = TextureRect.new()
		ship_icon.texture = ship_scene
		ship_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		%HealthContainer.add_child(ship_icon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
