extends Area2D
@onready var sprite: AnimatedSprite2D = $sprite
signal finished()
@onready var shape: CollisionShape2D = $shape
@onready var attack_time: Timer = $attack_time
var damage := 5
@onready var light: PointLight2D = $light
var counter:= 0
# Called when the node enters the scene tree for the first time.
func _set_direction(d:float)->void:
	if d== 1.0:
		sprite.flip_h = true
		sprite.position.x *= -1
		shape.position.x  *= -1
		light.position.x  *= -1
func _set_time(d:int)->void:
	attack_time.wait_time = d
func _set_damage(d:int)-> void:
	damage = d
func _ready() -> void:
	shape.disabled = true
	sprite.play("fire_init")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter += 1
	if counter > 15:
		counter = 0
		light.energy = randf_range(0.9,2)
		light.texture_scale = randf_range(2.5,4)
	pass


func _on_sprite_animation_finished() -> void:
	if sprite.animation == "fire_init":
		attack_time.start()
		sprite.play("fire_loop")
		shape.disabled = false
	if sprite.animation == "fire_end":
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("hurted",damage)


func _on_attack_time_timeout() -> void:
	shape.disabled = true
	sprite.play("fire_end")
	emit_signal("finished")
