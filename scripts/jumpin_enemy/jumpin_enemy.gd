extends Area2D

@onready var sprite: AnimatedSprite2D = $sprite
@onready var shape: CollisionShape2D = $shape
@onready var jump_time: Timer = $jumpTime

@export var final_position: Vector2
@onready var init_position:=position
@export var speed: float 
@export var move:= true
func _move_tween() -> void:
	var mv:=create_tween()
	mv.tween_property(self,"position",final_position,speed/2).set_ease(Tween.EASE_IN)
func _process(delta: float) -> void:
	if position == init_position and jump_time.is_stopped():
		jump_time.start()
func _on_jump_time_timeout() -> void:
	_move_tween()
func _physics_process(delta: float) -> void:
	position.y += get_gravity()/4*delta
