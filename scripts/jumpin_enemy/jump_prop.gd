extends RigidBody2D
@onready var again: Timer = $again
@export var damage: int
@export_range(300.0,1000.0) var y_force:= 2.0
@onready var init_position := position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	again.wait_time=randf_range(1,3)
	apply_central_impulse(Vector2(0,-y_force))

func _on_again_timeout() -> void:
	position = init_position
	set_freeze_enabled(false)

	apply_central_impulse(Vector2(0,-y_force))
func _physics_process(delta: float) -> void:
	if position.y > init_position.y and again.is_stopped():
		set_freeze_enabled(true)
		again.start()


func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("hurted",damage)
