extends Area2D
@onready var shape: CollisionShape2D = $shape

@export var blade_power:int = 1
@export_range(0.0,0.7) var attack_duration :float
signal finished()
signal started()
@onready var x_length:float
func _ready() -> void:
	area_switch()
	x_length = shape.position.x
func area_switch() -> void:
	set_monitoring(not is_monitoring())
	set_monitorable(not is_monitorable())
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("hurted", blade_power)
func activate(direction: float) -> void:
	set_direction(direction)
	emit_signal("started")
	area_switch()
	await get_tree().create_timer(attack_duration).timeout
	area_switch()
	emit_signal("finished")
func set_direction(direction:float) -> void:
	if direction == -1.0:
		shape.position.x = x_length*-1
	if direction == 1.0:
		shape.position.x = x_length
		
