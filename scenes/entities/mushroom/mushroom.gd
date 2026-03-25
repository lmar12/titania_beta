extends "res://scripts/simulBody/simulBody.gd"
@export var minimun_distance: float = 10.0
enum States {WAIT, SPAWN, ATTACK}
var state := States.WAIT
const ROAR = preload("res://assets/entities/mushroom/Retro Roar Krushed 01.wav")
# Called when the node enters the scene tree for the first time.
func active_area() -> void:
	set_monitoring(true)
	set_monitorable(true)
func _ready() -> void:
	direction_x = 1.0
	set_monitoring(false)
	set_monitorable(false)
	sprite.set_animation("spawn")
func check_target() -> void:
	direction_x = check_target_direction()
	match direction_x:
		1.0: sprite.set_flip_h(false)
		-1.0:sprite.set_flip_h(true) 
func _process(delta: float) -> void:
	match state:
		States.WAIT:
			if distance_to_target() < minimun_distance:
				sfx.set_stream(ROAR)
				sfx.set_pitch_scale(1.9)
				sfx.play(0.6)
				check_target()
				sprite.play("spawn")

				await sprite.animation_finished
				state=States.ATTACK
				sprite.play("run")
				sfx.set_pitch_scale(1)
				active_area()
		States.ATTACK:
			move = true
			pass
			#position.x = lerp(position.x,position.x + direction_x*speed,0.6)
func kamikaze(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("takeDamage",1)
func _physics_process(delta: float) -> void:
	if move:
		super._physics_process(delta)
	if side_left.is_colliding() or side_right.is_colliding():
		emit_signal("takeDamage",1)
	
