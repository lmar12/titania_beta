extends Node
@export var player: Player
var parallax_changed := false
@onready var parallax_wn: ParallaxBackground = $parallaxWn
@onready var parallax_mist: ParallaxBackground = $parallaxMist
@onready var end_canvas: CanvasLayer = $endCanvas
@onready var enemy: Node = $Enemy
func _ready() -> void:
	$gui_canvas.hide()
	$close.hide()
	pass
func _check_x_player() -> void:
	if not parallax_changed:
		if player.position.x > 4000:
			parallax_mist.hide()
			parallax_wn.visible = true
			parallax_changed = true
func _process(delta: float) -> void:
	_check_x_player()


func _on_final_flag_a_touched(pos: Vector2) -> void:
	print("fin")
	var tw:=create_tween()
	tw.tween_property($song,"volume_db",-70.0,1).set_trans(Tween.TRANS_QUAD)
	$close.show()
	$close.close_viewport(1)
func change_last_position(v:Vector2)->void:
	PlayerSingleton.last_init_position = v


func _on_start_finished() -> void:
	$song.play()
	$gui_canvas.show()
	player.start(PlayerSingleton.last_init_position)


func _on_close_finished() -> void:
	PlayerSingleton.next_level()
