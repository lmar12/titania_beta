extends CanvasLayer
@onready var label: Label = $CenterContainer/VBoxContainer/Label
var counter:=0
const max_counter:=7
var indx := 0
var colors:PackedColorArray=[Color.BISQUE,Color.BROWN,Color.CRIMSON,Color.DARK_ORANGE]
@onready var center_container: CenterContainer = $CenterContainer
@onready var scr: Polygon2D = $Node/scr
@onready var node: Node = $Node

signal finished()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter += 1
	if counter > max_counter:
		if  indx+1 < colors.size()-1: indx += 1
		else: indx = 0
		
		label.modulate = colors[indx]
		counter = 0


func _on_start_finished() -> void:
	emit_signal("finished")
	center_container.hide()
	var nt:=node.create_tween()
	nt.tween_property(scr,"offset",Vector2(-360,0),1).set_trans(Tween.TRANS_QUAD)
	nt.connect("finished",func()->void:
		scr.hide()
		emit_signal("finished"))
