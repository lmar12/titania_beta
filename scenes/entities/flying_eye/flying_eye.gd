extends "res://scripts/enemy2/enemy2.gd"
@export var final_position: Vector2
@export_range(3,10) var duration := 3 
var init_position : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_position = position
	direction_x = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position == init_position:
		var move:=create_tween()
		direction_x = 1
		move.tween_property(self,"position",final_position,duration)
	if position == final_position:
		direction_x = -1
		var move:=create_tween()
		move.tween_property(self,"position",init_position,duration)
	match direction_x:
		-1: sprite.set_flip_h(true)
		1 : sprite.set_flip_h(false)
