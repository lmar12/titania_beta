extends Area2D
signal chest_opened()
var opened:=false
func _ready() -> void:
	hide()
func appear(v:Vector2)->void:
	position = v
	show()
	$sprite.play("appear")
	$appearSound.play()
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not opened:
		$open.play()
		opened = true
		$sprite.play("open")
		emit_signal("chest_opened")
