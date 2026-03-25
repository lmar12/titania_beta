extends AnimatedSprite2D
@export var final_scale: Vector2
@onready var init_scale: Vector2 = scale
# Called when the node enters the scene tree for the first time.
func appear() -> void:
	var tw:=create_tween().set_loops(2)
	tw.set_parallel(true)
	tw.tween_property(self,"modulate",Color(1,1,1,1),0.5)
	tw.chain().tween_property(self,"modulate",Color(1,1,1,0),0.5)
	tw.tween_property(self,"scale",init_scale+final_scale,0.5)
	tw.chain().tween_property(self,"scale",init_scale,0.5)


func _on_timer_timeout() -> void:
	appear()
