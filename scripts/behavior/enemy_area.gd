extends Area2D
class_name EnemyArea
@export var damage_given: int = 1
signal desactivate()
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("hurted", damage_given)


func _on_desactivate() -> void:
	set_collision_mask_value(2,false)
	set_monitoring(false)
	$CollisionShape2D.disabled = true
