extends Label
const final_position:=Vector2(48,40)
signal finished()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tw:=create_tween()
	tw.tween_property(self,"position",final_position,1.5).set_trans(Tween.TRANS_QUAD)
	tw.connect("finished",func()->void:
		emit_signal("finished")
		$introSound.play())
