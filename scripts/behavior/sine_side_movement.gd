extends Node
class_name SineSideMovement
@export var entity_body: CharacterBody2D
@export var actor_behavior: ActorBehavior
@export_range(1.0,10.0) var amplitude: float
@export_range(1.0,50.0) var travel_length: float
@export_range(100.0,400.0) var ratio: float
@export var play: bool = true
@onready var init_position: Vector2 = entity_body.position
signal is_playing()
signal not_playing()
func switch_play() -> void:
	play = not play
	if play: emit_signal("is_playing")
	if not play:    emit_signal("not_playing")
func _physics_process(delta: float) -> void:
	if play:
		if entity_body.position.distance_to(init_position) > travel_length:
			actor_behavior.flip_x_direction()
		entity_body.velocity.x = actor_behavior.get_velocity().x
	else:
		entity_body.velocity.x = 0
	entity_body.velocity.y = lerpf(entity_body.velocity.y, sin(Time.get_ticks_msec()/ratio)*amplitude, 0.5)
	
	entity_body.move_and_slide()
		
	
