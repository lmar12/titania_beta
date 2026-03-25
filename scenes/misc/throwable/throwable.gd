extends Area2D
@export_range(1,100) var damage: int = 1
@export var target: CharacterBody2D
@export var impact_anim: SpriteFrames
@export var throw_sound: AudioStream
@export var hit_sound: AudioStream
func _ready() -> void:
	$soundPlayer.set_stream(throw_sound)
	$soundPlayer.play()
func _on_body_entered(body: Node2D) -> void:
	$soundPlayer.set_stream(hit_sound)
	$soundPlayer.play()
	#if body.has_signal("take_damage"):
	#	body.emit_signal("take_damage", damage)
	$CollisionShape2D.disabled = true
	set_collision_layer_value(2,false)
	set_collision_mask_value(2,false)
	if impact_anim:
		$AnimatedSprite2D.set_sprite_frames(impact_anim)
		$AnimatedSprite2D.play()
		await($AnimatedSprite2D.animation_finished)
	queue_free()
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
func get_target_position() -> Vector2:
	if target:
		return target.get_position()
	return Vector2()
func set_target(body: CharacterBody2D) -> void:
	target = body
func set_new_position(pos: Vector2) -> void:
	position = pos
