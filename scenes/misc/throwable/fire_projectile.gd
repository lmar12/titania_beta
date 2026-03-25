extends "res://scenes/misc/throwable/throwable.gd"
@onready var projectile_movement: ProjectileMovement = $projectileMovement
var counter:=0
const max_counter=15
func _ready() -> void:
	$AnimatedSprite2D.set_scale(Vector2(randf_range(1,1.3),randf_range(1,1.3)))
func _process(delta: float) -> void:
	counter += 1
	if counter > max_counter:
		var randC:=randf_range(0.2,1)
		counter = 0
		$AnimatedSprite2D.set_modulate(Color(1,randC,randC))
func _on_enemy_area_body_entered(body: Node2D) -> void:
	$EnemyArea.emit_signal("desactivate")
func set_direction(dir:Vector2) -> void:
	projectile_movement.angle_direction(dir)
func set_random_speed()->void:
	projectile_movement.rand_speed()
