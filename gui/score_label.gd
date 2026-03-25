extends Label
func set_score(s:String)->void:
	set_text(s)
func _ready() -> void:
	get_tree().create_timer(0.7).connect("timeout",func()->void:
		queue_free())


func _process(delta: float) -> void:
	position.y -= 0.5
