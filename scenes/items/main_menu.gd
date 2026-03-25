extends Control
var start_active:=false
signal intro_pressed()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start_active and Input.is_action_just_pressed("start"):
		$introPressed.play()
		emit_signal("intro_pressed")
		var tw:=create_tween().set_loops(20)
		tw.tween_callback(self.set_modulate.bind(Color.RED)).set_delay(0.1)
		tw.tween_callback(self.set_modulate.bind(Color.TOMATO)).set_delay(0.1)
		tw.tween_callback(self.set_modulate.bind(Color.ORANGE)).set_delay(0.1)
		tw.tween_callback(self.set_modulate.bind(Color.WHITE)).set_delay(0.1)
		$close.show()
		$close.close_viewport(2)


func _on_game_title_finished() -> void:
	$music.play()
	$center.appear()
	start_active = true
	


func _on_close_finished() -> void:
	PlayerSingleton.next_level()
