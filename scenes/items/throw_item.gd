extends "res://scenes/misc/items/item.gd"


func spicy() -> void:
	var tw:=create_tween()
	tw.set_loops(3)
	tw.tween_property($AnimatedSprite2D,"scale",Vector2(-1,1),1).set_trans(Tween.TRANS_QUAD)
	tw.chain().tween_property($AnimatedSprite2D,"scale",Vector2(1,1),1).set_trans(Tween.TRANS_QUAD)
	get_tree().create_timer(5).connect("timeout",func()->void:
		spicy())
func _ready() -> void:
	spicy()
	$halo.spicy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
