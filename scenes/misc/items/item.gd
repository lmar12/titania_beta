extends Area2D
enum types {GEM,POWER_UP,LIFE,KEY,THROWABLE}
@export var score: int
@export var item_type: types
@export_range(1,10) var modifier: int = 1 ##for gems and life
@export var apply_gravity: bool = true
@export_range(2,15) var gravity_force: float
signal key_pick_up()
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		match item_type:
			types.GEM:
				body.emit_signal("takeGem", modifier)
			types.LIFE:
				body.emit_signal("takeLife", modifier)
			types.POWER_UP:
				body.emit_signal("takePowerUp")
			types.KEY:
				emit_signal("key_pick_up")
			types.THROWABLE:
				body.emit_signal("takeThrowable",modifier)
		body.emit_signal("changeScore", score)
		pick_up()
func _physics_process(delta: float) -> void:
	if apply_gravity:
		if not $down.is_colliding():
			position.y += 10 * delta
			position.x  = lerp(position.x, position.x + sin(Time.get_ticks_msec()/120.0), 0.5)
func pick_up() -> void:
	$AnimatedSprite2D.set_visible(false)
	$CollisionShape2D.set_disabled(true)
	$pickSound.play()
	await($pickSound.finished)
	queue_free()
func move(pos: Vector2):
	position = pos
func tilt() -> void:
	var tween:=create_tween().set_loops(10)
	tween.tween_callback(self.set_modulate.bind(Color(1,1,1,0))).set_delay(0.1)
	tween.tween_callback(self.set_modulate.bind(Color(1,1,1,1))).set_delay(0.1)
