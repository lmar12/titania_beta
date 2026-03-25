extends StaticBody2D
@onready var appear_sound: AudioStreamPlayer = $appearSound

func _ready() -> void:
	hide()

func appear() ->void:
	show()
	$AnimatedSprite2D.play()
	
	#set_collision_mask_value(1,true)
	set_collision_layer_value(1,true)
func disappear()->void:
	$AnimatedSprite2D.play_backwards("init")
	set_collision_layer_value(1,false)
	await get_tree().create_timer(2).timeout
	hide()
func _process(delta: float) -> void:
	if $AnimatedSprite2D.frame%3==0 and $AnimatedSprite2D.frame!=0:
		appear_sound.play()
