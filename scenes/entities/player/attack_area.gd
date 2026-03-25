extends Area2D
var active: bool = false
var shapeDirection: Dictionary = {-1: Vector2(-8,0), 1:Vector2(8,0)}
func desactivate() -> void:
	set_monitoring(false)
func activate(facing: int) -> void:
	if not active:
		$attackSounds.emit_signal("missed")
		$attackShape.set_position(shapeDirection[facing])
		$attackShape.set_disabled(false)
		$attackTime.start()
		active = true
	if active:
		$attackSounds.emit_signal("missed")
		$attackTime.start()
func _on_attack_time_timeout() -> void:
	active = false
	$attackShape.set_disabled(true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.emit_signal("take_damage", get_parent().sword_power)
		$attackSounds.emit_signal("hitted")
func is_actived()-> bool:
	return active


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("destroyable"):
		area.emit_signal("destroy")
		$attackSounds.emit_signal("hitted")
		#feo
		get_parent().emit_signal("changeScore", area.score)
	if area.is_in_group("enemies2"):
		area.emit_signal("takeDamage", get_parent().sword_power)
		get_parent().emit_signal("changeScore", area.score)
