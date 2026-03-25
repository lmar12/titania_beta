extends AnimatedSprite2D
class_name SpriteEntity
@export var actor_behavior: ActorBehavior
@export_group("Damage")
@export var damage_color: Color = Color.CRIMSON
@export_range(0.05,1.0) var damage_time: float = 0.2
func _ready() -> void:
	actor_behavior.connect("direction_changed", Callable(self, "switch_flip"))
	actor_behavior.connect("speed_changed", Callable(self, "speed_scale"))
func switch_flip() -> void:
	set_flip_h(not is_flipped_h())
func speed_scale() -> void:
	set_speed_scale(log(actor_behavior.speed-1)/log(10))
func change_anim(name: String):
	play(name)
func simul_damage(d: int) -> void:
	set_modulate(Color.CRIMSON)
	await(get_tree().create_timer(0.2).timeout)
	set_modulate(Color.WHITE)
