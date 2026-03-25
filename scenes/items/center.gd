extends CenterContainer
var tw:Tween

# Called when the node enters the scene tree for the first time.
func appear()->void:
	tw=create_tween().set_loops()
	tw.tween_callback(self.set_modulate.bind(Color(0,0,0,1))).set_delay(.5)
	tw.tween_callback(self.set_modulate.bind(Color(0.5,0.5,0.5,1))).set_delay(.5)
	tw.tween_callback(self.set_modulate.bind(Color(1,1,1,2))).set_delay(.5)
func stopr()->bool:
	if Input.is_action_just_pressed("start"):
		return true
	return false


func _on_main_menu_intro_pressed() -> void:
	tw.kill()
