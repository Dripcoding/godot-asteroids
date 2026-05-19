extends Node2D


var ship_scene: CompressedTexture2D = preload('res://PNG/playerShip2_red.png')
var time_elapsed: float = 0
var is_game_active: bool = true


func _ready() -> void:
	for i in range(%Player.health, 0, -1):
		var ship_icon = TextureRect.new()
		ship_icon.texture = ship_scene
		ship_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		%HealthContainer.add_child(ship_icon)
	
	%Player.damage_taken.connect(_on_player_take_damage)
	%Player.health_depleted.connect(_on_player_health_depleted)


func _process(delta: float) -> void:
	if is_game_active:
		time_elapsed += delta
		%ScoreLabel.text = "Score: " + str(int(time_elapsed))


func _on_player_take_damage() -> void:
	if %HealthContainer.get_child_count() > 0:
		%HealthContainer.get_child(-1).queue_free()


func _on_player_health_depleted() -> void:
	is_game_active = false
