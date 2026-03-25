extends "res://scripts/enemy.gd"
enum States {WAIT, ATTACK}
var state: States = States.WAIT
var min_distance: float = 100.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_state()
func update_state() -> void:
	match state:
		States.WAIT:
			seek()
			tilt()
			if position.distance_to(target.position) < min_distance:
				change_state(States.ATTACK)
				pass
		States.ATTACK:
			if is_on_wall():
				$LifeComponent.take_damage(1)
func change_state(new_state: States) -> void:
	match new_state:
		States.ATTACK:
			$Timer.start()
			var new_tween := create_tween()
			$SpriteEntity.play("attack")
			new_tween.tween_property(self, "velocity",position.direction_to(target.position)*$ActorBehavior.speed*2,0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	state = new_state
func tilt() -> void:
	position.y = lerpf(position.y,position.y + sin(Time.get_ticks_msec()/120.0)*2.0,0.1)

func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_timer_timeout() -> void:
	$LifeComponent.emit_signal("life_depleted")
