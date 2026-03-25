extends "res://scripts/enemy.gd"
enum States {IDLE, ATTACK}
var state := States.IDLE
var min_distance := 100.0
var dead := false
const FIRE_PROJECTILE = preload("res://scenes/misc/throwable/fire_projectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_state() -> void:
	match state:
		States.IDLE:
			seek()
			if distace_to_target() < min_distance:
				change_state(States.ATTACK)
		States.ATTACK:
			seek()
			if distace_to_target() > min_distance:
				change_state(States.IDLE)
func change_state(new_state: States) -> void:
	match new_state:
		States.ATTACK:
			$SpriteEntity.change_anim("attack")
			#$SideMovement.play = false
		States.IDLE:
			$SpriteEntity.change_anim("idle")
			#$SideMovement.play = true
	state= new_state
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_state()
	match $ActorBehavior.direction.x:
		-1.0:
			$SpriteEntity.flip_h = false
		1.0:
			$SpriteEntity.flip_h = true
func _on_sprite_entity_animation_finished() -> void:
	var new_shoot := FIRE_PROJECTILE.instantiate()
	new_shoot.set_target(target)
	new_shoot.set_new_position(position+Vector2(0,-5))
	await get_tree().create_timer(0.03).timeout
	if not dead:
		get_parent().add_child(new_shoot)
	$SpriteEntity.play()
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = (get_gravity() * delta).y
	match state:
		States.IDLE:
			velocity = $ActorBehavior.direction
			if not $left.is_colliding():
				velocity.x = 1
			if not $right.is_colliding():
				velocity.x = -1
	move_and_slide()
		


func _on_life_component_life_depleted() -> void:
	dead = true
