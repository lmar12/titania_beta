extends SideMovement
class_name SideMovementWithJump
@export_range(1.0,100.0) var jump_speed := 1.0
@export var direction_ray: RayCast2D
@export var sprite: SpriteEntity
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	super(delta)
	if direction_ray.is_colliding():
		print("hola")
		entity_body.velocity.y = -jump_speed * 10
	if entity_body.velocity.y != 0:
		sprite.change_anim("jump")
	else:
		sprite.change_anim("run")
