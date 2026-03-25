extends "res://scripts/enemy2/enemy2.gd"
enum States {INIT,IDLE,MOVE,ATTACK,DEATH,FIRESHOWER,NULL}
@export var final_position:Vector2
var state:=States.NULL
@onready var follow_2d: PathFollow2D = $Path2D/PathFollow2D
var last_point:int = 0
var progress_points: PackedFloat32Array = [0.0,0.1662,0.5353,0.6898,0.9999]
var attack_points: PackedInt32Array = [1,2]
var rest_points: PackedInt32Array  = [0,3,4]

@onready var wait: Timer = $wait
const FIREPOWER = preload("res://scenes/bosses/erlkonig/firepower.tscn")
var ready_to_move:=false
var move_finished:=false
@export var FIRESHOWER:ShotPaths

signal boss_defeated()
signal ready_to_fight()
func _ready() -> void:
	FIRESHOWER.connect("finished",Callable(self,"_on_fireshower_finished"))
	#FIRESHOWER.connect("shooted",Callable(self,"rapid_shoots"))
	#_change_state(States.INIT)
	
	pass # Replace with function body.
func activate()->void:
	_change_state(States.INIT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state != States.NULL and state != States.INIT:
		position = follow_2d.position
	_update_state()
	match direction_x:
		-1:
			sprite.flip_h = false
		1:
			sprite.flip_h = true
	if follow_2d.progress_ratio > 0.34 and follow_2d.progress_ratio < 0.84:
		direction_x = 1
	if follow_2d.progress_ratio > 0.84 or follow_2d.progress_ratio <0.34:
		direction_x = -1

func _update_state() -> void:
	match state:
		States.NULL:
			pass
		States.INIT:
			pass
			if position == final_position:
				$initSound.play()
				emit_signal("ready_to_fight")
				_change_state(States.IDLE)
		States.IDLE:
			if ready_to_move:
				_change_state(States.MOVE)
		States.MOVE:
			if last_point in attack_points and move_finished:
				_change_state(States.ATTACK)
			if last_point in rest_points:
				_change_state(States.IDLE)
		States.ATTACK:
			move_finished = false
			if ready_to_move:
				_change_state(States.MOVE)
			pass
		States.FIRESHOWER:
			pass
			

func _change_state(new_state:States) -> void:
	
	match new_state:
		States.INIT:
			sprite.play("move")
			create_tween().tween_property(self,"position",follow_2d.position,4).set_trans(Tween.TRANS_BOUNCE)
		States.IDLE:

			wait.start()
		States.MOVE:
			ready_to_move = false
			sprite.play("move")
			next_progress_point()
			if last_point != 0:
				var move_tween:=create_tween()
				move_tween.connect("finished",func()-> void:
					move_finished = true)
				move_tween.tween_property(follow_2d,"progress_ratio",progress_points[last_point],3).set_trans(Tween.TRANS_EXPO)
				
		States.ATTACK:
			$attack.play()
			sprite.play("attackInit")
			pass
		States.FIRESHOWER:
			$shape.set_deferred("disabled",true)
			var tween:=create_tween()
			FIRESHOWER.start()
			tween.tween_property(sprite,"modulate",Color(0,0,1,0),1)
	#print(str(last_point))
	state = new_state
func _on_wait_timeout() -> void:
	ready_to_move = true
func next_progress_point() -> void:
	if last_point >= progress_points.size()-1:
		if state != States.FIRESHOWER:
			_change_state(States.FIRESHOWER)
		_reset_routine()
	else:
		last_point += 1 
func perform_attack() -> void:
	var new_attack:= FIREPOWER.instantiate()
	
	new_attack.connect("finished",func move()-> void:
		ready_to_move = true)
	add_child(new_attack)
	new_attack._set_direction(direction_x)
	pass
func _reset_routine() -> void:
	last_point = 0
	follow_2d.progress_ratio = 0.0
	move_finished=false
	ready_to_move=false
	$shape.set_deferred("disabled",false)

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "attackInit":
		perform_attack()
		sprite.play("attackLoop")
func defeated() -> void:
	emit_signal("boss_defeated")
	set_process(PROCESS_MODE_DISABLED)
	hide()
	queue_free()
func rapid_shoots(p:Vector2)->void:
	var t:=create_tween()
	sprite.play("rapid_shoots")
	sprite.position = to_local(p)
	t.tween_property(sprite,"modulate",Color(1,1,1,1),0.5)
	t.chain().tween_property(sprite,"modulate",Color(0,0,1,1),0.5)


func _on_fireshower_finished() -> void:
	_reset_routine()
	var t:=create_tween()
	t.tween_property(sprite,"modulate",Color(1,1,1,1),0.5)
	_change_state(States.MOVE)
