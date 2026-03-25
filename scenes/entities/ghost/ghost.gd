extends "res://scripts/enemy.gd"
enum States {WAIT, ATTACK}
var state: States = States.WAIT

var min_distance: float = 90.0
func _ready() -> void:
	change_state(States.WAIT)
func _process(delta: float) -> void:
	update_state()
	match $ActorBehavior.direction.x:
		-1.0:
			$SpriteEntity.flip_h = true
		1.0:
			$SpriteEntity.flip_h = false
	
func update_state() -> void:
	match state:
		States.WAIT:
			seek()
			if position.distance_to(target.position) < min_distance \
			and float(target.facing) != $ActorBehavior.direction.x:
				change_state(States.ATTACK)
		States.ATTACK:
			chase()
			seek()
			if float(target.facing) == $ActorBehavior.direction.x:
				change_state(States.WAIT)
func change_state(new_state: States) -> void:
	match new_state:
		States.WAIT:
			dissappear()
			$EnemyArea/CollisionShape2D.disabled = true
			$SpriteEntity.stop()
		States.ATTACK:
			appear()
			$SpriteEntity.play()
			await(get_tree().create_timer(0.5).timeout)
			$EnemyArea/CollisionShape2D.disabled = false
			
		
	state = new_state
func chase() -> void:
	var new_tween: Tween = create_tween()
	new_tween.tween_property(self,"position",target.position,$ActorBehavior.speed/10).set_ease(Tween.EASE_OUT)
func dissappear() -> void:
	var new_tween: Tween = create_tween()
	new_tween.tween_property(self,"modulate",Color(1,1,1,0.5),1)
func appear() -> void:
	var new_tween: Tween = create_tween()
	new_tween.tween_property(self,"modulate",Color(1,1,1),1)
