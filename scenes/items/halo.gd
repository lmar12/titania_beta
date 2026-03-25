extends Sprite2D


func spicy()->void:
	var tw:=create_tween().set_loops(3)
	tw.set_parallel(true)
	tw.tween_property(self,"modulate",Color(1,1,1,0.5),0.3)
	tw.chain().tween_property(self,"modulate",Color(1,1,1,0.0),0.3)
	tw.tween_property(self,"scale",Vector2(1.2,1.2),.5).set_trans(Tween.TRANS_QUART)
	tw.chain().tween_property(self,"scale",Vector2(.5,.5),.5)
	
	get_tree().create_timer(7).connect("timeout",func()->void:
		spicy())
