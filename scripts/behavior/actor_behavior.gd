extends Node
class_name ActorBehavior
@export_range(1.0,100) var speed: float
@export_enum("left:-1","right:1","none:0") var default_direction: int
var direction : Vector2 = Vector2()
var last_x_direction: float = 0.0
signal direction_changed
signal speed_changed
func _ready() -> void:
	direction.x = default_direction
	emit_signal("speed_changed")
func _process(delta: float) -> void:
	if last_x_direction != direction.x and direction.x != 0:
		last_x_direction = direction.x
func set_direction(dir: Vector2) -> void:
	direction = dir
	emit_signal("direction_changed")
func flip_x_direction() -> void:
	direction.x *= -1
	emit_signal("direction_changed")
func get_velocity() -> Vector2:
	return direction * speed
func set_speed(s: float) -> void:
	self.speed = s
