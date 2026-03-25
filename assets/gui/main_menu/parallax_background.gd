extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ParallaxLayer.motion_offset.x = lerpf($ParallaxLayer.motion_offset.x,$ParallaxLayer.motion_offset.x-2*delta,0.5)
	$ParallaxLayer2.motion_offset.x = lerpf($ParallaxLayer2.motion_offset.x,$ParallaxLayer2.motion_offset.x-3*delta,0.5)
	$ParallaxLayer3.motion_offset.x = lerpf($ParallaxLayer3.motion_offset.x,$ParallaxLayer3.motion_offset.x-4*delta,0.5)
