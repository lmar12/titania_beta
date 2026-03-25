extends Node
class_name ProjectileMovement
@export var area_to_move : Area2D
@export var sprite: AnimatedSprite2D
@export_range(1.0,100.0) var speed: float
var active: bool = true
var direction: Vector2 = Vector2()
func _ready() -> void:
	sprite.connect("sprite_frames_changed", func() -> void:
		active = false)
	target_to(area_to_move.get_target_position())
func target_to(target: Vector2) -> void:
	direction = area_to_move.position.direction_to(target)
	sprite.rotate(Vector2.RIGHT.angle_to(direction))
func _physics_process(delta: float) -> void:
	if active:
		area_to_move.position += direction * speed * delta
func angle_direction(dir:Vector2) -> void:
	direction = dir
	sprite.rotate(Vector2.RIGHT.angle_to(direction))
func set_speed(f:float) -> void:
	speed = f
func rand_speed()->void: 
	speed = randf_range(100.0,150.0)
