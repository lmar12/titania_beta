extends Node
@onready var player: Player = $player
func _ready() -> void:
	player.start(Vector2(128,208))
