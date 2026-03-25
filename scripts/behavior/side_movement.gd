extends Node
class_name SideMovement
@export var entity_body: CharacterBody2D
@export var actor_behavior: ActorBehavior
@export var red_turtleish: bool = true
@export var left_ray :RayCast2D
@export var right_ray:RayCast2D
@export var play: bool = true
@onready var last_position: Vector2 = Vector2(entity_body.position)

func _physics_process(delta: float) -> void:
	if not entity_body.is_on_floor():
		entity_body.velocity += entity_body.get_gravity() * delta
	if play:
		if red_turtleish:
			if (not left_ray.is_colliding() and actor_behavior.direction == Vector2.LEFT) or \
			(not right_ray.is_colliding() and actor_behavior.direction == Vector2.RIGHT):
				actor_behavior.flip_x_direction()
		if last_position == entity_body.position:
			actor_behavior.flip_x_direction()
		else:
			last_position = Vector2(entity_body.position)
		entity_body.velocity.x = actor_behavior.get_velocity().x
	else:
		entity_body.velocity.x = 0
	entity_body.move_and_slide()
