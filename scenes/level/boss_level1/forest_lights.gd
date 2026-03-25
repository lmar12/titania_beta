extends Sprite2D
@export var radius:float = 20
@export var color_init: Color
@onready var init_position:=position
# Called when the node enters the scene tree for the first time.
func rand_position() -> void:
	position.x = randf_range(init_position.x-radius,init_position.x+radius)
	position.y = randf_range(init_position.y,init_position.y-radius)
func motion() -> void:
	var rx:=create_tween()
	rx.tween_property(self,"modulate",color_init,randf_range(2,5))
	rx.chain().tween_property(self,"modulate",Color(1,1,1,0),randf_range(2,5))
	rx.connect("finished",func()->void:
		rand_position()
		motion())
func _ready() -> void:
	rand_position()
	motion()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
