extends CanvasLayer
@onready var gui := $playerGui
@export var player: Player
@export var boss: PackedScene
func _ready() -> void:
	gui._set_life(20)
	player.connect("takeGem", Callable(gui,"_update_gem"))
	player.connect("changeScore", Callable(gui,"_update_score"))
	player.connect("takeLife", Callable(gui,"_update_life"))
	player.connect("hurted", Callable(gui,"_update_life_neg"))
	player.connect("takeThrowable",Callable(gui,"change_item"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func set_stage(s:String)->void:
	gui.set_stage(s)
func change_item(t:int)->void:
	gui.change_item(t)
