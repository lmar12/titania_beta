extends Node
@onready var player: Player = $player
@onready var dyna_wall: StaticBody2D = $dynaWall
const stop_parse:=Vector2(64,208)
var on_battle_room:=false
var boss_defeated:= true
var closed:=false
@onready var player_camera: Camera2D = $player/playerCamera
@onready var erlkonig: Area2D = $erlkonig
@onready var gui_canvas: CanvasLayer = $gui_canvas
@onready var dyna_wall_2: StaticBody2D = $dynaWall2
@onready var patetique: AudioStreamPlayer = $Patetique



func _make_wall() -> void:
	dyna_wall.appear()
	dyna_wall_2.appear()
func _ready() -> void:
	
	gui_canvas.set_stage("BOSS 1")
func _init_battle()->void:
	patetique.play()
	if player.position.x >= stop_parse.x:
		#player
		on_battle_room = true
		player_camera.limit_left = -50
		var new_tween:=create_tween()
		new_tween.tween_property(player_camera,"limit_left",0,1).set_trans(Tween.TRANS_QUAD)
		_make_wall()
		player.desactivate()
		#get_tree().create_timer(2).connect("timeout",func()-> void:
		#	player.activate())
		erlkonig.activate()
		erlkonig.connect("ready_to_fight",func()->void:
			player.activate())
		#boss
func _process(delta: float) -> void:
	if not on_battle_room:
		_init_battle()
	if player.position.x > 340 and boss_defeated and not closed:
		closed=true
		$close.show()
		$close.close_viewport(1)
		
	pass


func _on_erlkonig_boss_defeated() -> void:
	var tw:=create_tween()
	tw.tween_property(patetique,"volume_db",-50.0,2).set_trans(Tween.TRANS_QUAD)
	$completed.play()
	
	$chest.appear(Vector2(160,216))


func _on_start_finished() -> void:
	player.start(Vector2(-248,208))
	pass # Replace with function body.


func _on_chest_chest_opened() -> void:
	$key.set_position(Vector2(158,150))
	$key.tilt()
	


func _on_key_key_pick_up() -> void:
	print("boss defeated!")
	dyna_wall_2.disappear()


func _on_close_finished() -> void:
	PlayerSingleton.next_level()
