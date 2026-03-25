extends RigidBody2D
class_name PlayerShots
@export var damage: int
@onready var sprite: AnimatedSprite2D = $sprite
@export var impuls:Vector2
@onready var attack_area: Area2D = $attackArea
@export var gem_use:int
# Called when the node enters the scene tree for the first time.
func mod_position(v:Vector2) -> void:
	position = v
func _ready() -> void:
	apply_central_impulse(impuls)

func _on_attack_area_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("enemies2"):
		area.emit_signal("takeDamage",damage)
	attack_area.monitoring = false
	set_freeze_enabled(true)
	set_sleeping(true)
	sprite.play("impact")
	await sprite.animation_finished
	queue_free()
func mod_direction(d:int) -> void:
	impuls.x *= d
	match d:
		-1:
			$sprite.set_flip_v(true)
func _on_visible_screen_exited() -> void:
	queue_free()
