extends "res://scripts/enemy2/enemy2.gd"
@onready var right: RayCast2D = $right
@onready var left: RayCast2D = $left
@onready var side_right: RayCast2D = $sideRight
@onready var side_left: RayCast2D = $sideLeft


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#apply_gravity = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	if left.is_colliding() or right.is_colliding():
		apply_gravity = false
		if not left.is_colliding() or side_left.is_colliding(): direction_x = 1
		if not right.is_colliding() or side_right.is_colliding():direction_x = -1
	else:
		apply_gravity = true
	match direction_x:
		1:  sprite.set_flip_h(true)
		-1: sprite.set_flip_h(false)
	super._physics_process(delta)
	position.x = lerp(position.x,position.x + direction_x*speed/10,1)
