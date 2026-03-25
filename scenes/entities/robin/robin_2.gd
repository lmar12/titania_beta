extends "res://scripts/enemy.gd"
enum States {IDLE, ATTACK}
var state: States = States.IDLE
var target_position: Vector2
const bias: float = 120.0
const FIRE_PROJECTILE = preload("res://scenes/misc/throwable/fire_projectile.tscn")
func _process(delta: float) -> void:
	target_position = Vector2(target.position)
	match state:
		States.IDLE:
			if target_position.distance_to(position) < bias:
				change_state(States.ATTACK)
		States.ATTACK:
			#var facing: float = position.angle_to_point(target_position)
			seek()
			if target_position.distance_to(position) > bias:
				change_state(States.IDLE)
			#if facing >= PI/2 and facing < PI:
			#	$ActorBehavior.flip_x_direction()
			
	pass
func change_state(new_stat: States) -> void:
	match new_stat:
		States.ATTACK:
			state = States.ATTACK
			$shootAwait.start()
			$SpriteEntity.play("attack")
			$SineSideMovement.switch_play()
		States.IDLE:
			state = States.IDLE
			$shootAwait.stop()
			$SpriteEntity.play("idle")
			$SineSideMovement.switch_play()


func _on_shoot_await_timeout() -> void:
	if state == States.ATTACK:
		var new_shoot := FIRE_PROJECTILE.instantiate()
		new_shoot.set_target(target)
		new_shoot.set_new_position(position)
		get_parent().add_child(new_shoot)
