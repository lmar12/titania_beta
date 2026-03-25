extends "res://scripts/enemy2/enemy2.gd"
var on_ceiling:= true
var sprite_flipping := true
var min_distance: float = randf_range(100.0,150.0)
var chase_direction: float = 0.0

var counter := 0.0
@onready var down: RayCast2D = $down

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.flip_v = sprite_flipping
	sprite.stop()
	apply_gravity = false
	pass # Replace with function body.

func _update_counter() -> float:
	if counter < 4:
		counter += 0.3
	return counter
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if on_ceiling and distance_to_target() < min_distance:
		on_ceiling = false
		sprite.flip_v = not sprite_flipping
		chase_direction = check_target_direction()
		if chase_direction == 1.0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		sprite.play()
func _physics_process(delta: float) -> void:
	if not on_ceiling:
		if not down.is_colliding():
			#position.y += get_gravity()/5 * delta
			apply_gravity = true
			super._physics_process(delta)
			position.x  = lerp(position.x, position.x + sin(Time.get_ticks_msec()/120.0), 0.5)
		if down.is_colliding():
			apply_gravity = false
			#var tween:= create_tween()
			#tween.tween_property(self,"position", position+Vector2(chase_direction,0)*speed,3)
			position.x = lerp(position.x,position.x + chase_direction*speed/10,1)
		
