extends AnimatableBody2D
@export var final_point: Vector2
@onready var init_point: Vector2 = position
@export_range(1,100) var duration: int 
func _process(delta: float) -> void:
	_move_plataform()
func _move_plataform() -> void:
	if position == init_point:
		var new_tween := create_tween()
		new_tween.tween_property(self,"position",final_point,duration)
	if position == final_point:
		var new_tween := create_tween()
		new_tween.tween_property(self,"position",init_point,duration)
