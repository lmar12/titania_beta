extends "res://scripts/enemy2/enemy2.gd"
@onready var shoot_time: Timer = $shootTime
const FIRE_PROJECTILE = preload("res://scenes/misc/throwable/fire_projectile.tscn")
enum States {IDLE,ATTACK}
var min_distance: float = 100.0
var state:= States.IDLE
@export_range(10.0,200.0) var radius: float
@onready var init_position:=position
var dead:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction_x = 1.0

func _side_move() -> void:
	if abs(init_position.x-position.x) > radius:
		direction_x *= -1
	position.x = lerp(position.x, position.x + direction_x*speed,0.3)

func tilt() -> void:
	position.y = lerp(position.y,position.y + cos(Time.get_ticks_msec()/240.0),0.5)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		States.IDLE:
			_side_move()
			if min_distance > distance_to_target():
				state = States.ATTACK
				sprite.play("attack")
		States.ATTACK:
			_shoot()
			direction_x = check_target_direction()
			if min_distance < distance_to_target():
				
				state = States.IDLE
				sprite.play("idle")
	tilt()
	match direction_x:
		1.0:
			sprite.set_flip_h(false)
		-1.0:
			sprite.set_flip_h(true)
	
func _shoot() -> void:
	if shoot_time.is_stopped():
		shoot_time.start()
	

func _on_shoot_time_timeout() -> void:
	if not dead:
		var new_sh:=FIRE_PROJECTILE.instantiate()
		new_sh.set_new_position(Vector2(position))
		new_sh.set_target(target)
		get_parent().add_child(new_sh)
func _set_dead() -> void:
	dead = true
