extends "res://scripts/simulBody/simulBody.gd"
@onready var blade_area: Area2D = $bladeArea
@export_range(10.0,100.0) var min_distance: float
@export_range(5.0,50.0) var search_radius: float
@onready var init_position := position
enum States {WAIT, ATTACK, ENGARDE}
var state:= States.WAIT
var preparing_attack:=false
var death:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction_x = 1.0
	sprite.set_animation("walk")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func pavear() -> void:
	if abs(init_position.x-position.x) > search_radius:
		direction_x *= -1
	position.x = lerp(position.x, position.x + direction_x*speed/10,0.2) 
func _process(delta: float) -> void:
	match direction_x:
		1.0: sprite.set_flip_h(false)
		-1.0:sprite.set_flip_h(true)
	match state:
		States.WAIT:
			pavear()
			if distance_to_target() < min_distance:
				state = States.ENGARDE
				sprite.play("idle")
				move = false
		States.ENGARDE:
			direction_x = check_target_direction()	
			if distance_to_target() > min_distance:
				state = States.WAIT
				sprite.play("walk")
			else:
				if not preparing_attack:
					#print("preparando ataque")
					preparing_attack = true
					await get_tree().create_timer(randf_range(1,1.5)).timeout
					state = States.ATTACK
					if not death:
						blade_area.activate(direction_x)
					

func destructor() -> void:
	blade_area.queue_free()
	death =true

func _on_blade_area_finished() -> void:
	state = States.ENGARDE
	sprite.play("idle")
	preparing_attack=false

func _on_blade_area_started() -> void:
	sprite.play("attack")
