extends CanvasLayer
signal finished()
func _ready() -> void:
	hide()
func close_viewport(s:int)->void:
	var tw:=$Node.create_tween()
	tw.tween_property($Node/scr,"offset",Vector2(360,0),s).set_trans(Tween.TRANS_EXPO)
	tw.connect("finished",func()->void:
		emit_signal("finished"))
	
