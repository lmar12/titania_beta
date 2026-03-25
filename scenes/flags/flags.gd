extends Area2D
enum types {FLAG_A,FLAG_B}
@export var type: types = types.FLAG_B
signal flagB_touched(pos:Vector2)
signal flagA_touched(pos:Vector2)
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
const SCORE_LABEL = preload("res://gui/score_label.tscn")
var touched:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type == types.FLAG_B:
		sprite.set_animation("flagB")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not touched:
		$flagchecked.play()
		sprite.play()
		match type:
			types.FLAG_A:
				emit_signal("flagA_touched",position)
			types.FLAG_B:
				emit_signal("flagB_touched",position)
		touched = true
	var nw_lbl:=SCORE_LABEL.instantiate()
	nw_lbl.set_position(Vector2(position.x,position.y-30))
	nw_lbl.set_score("CHECKPOINT!")
	get_parent().add_child(nw_lbl)
	
