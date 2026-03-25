extends AnimatedSprite2D
const JUMP_PROP = preload("res://assets/misc/playerfx/jump/jumpProp.tres")
const LAND_PROP = preload("res://assets/misc/playerfx/land/landProp.tres")
const LAND_SFX = preload("res://assets/misc/playerfx/land/landSfx.wav")
const JUMP_SFX = preload("res://assets/misc/playerfx/jump/jumpSfx.wav")
const SIDEJUMP = preload("res://assets/fx/sideJump/sidejump.tres")
const JUMP_SIDE = preload("res://assets/fx/sideJump/jumpSide.wav")
var Props :Dictionary = {"land": LAND_PROP,"jump": JUMP_PROP,"side":SIDEJUMP}
var Sfxs: Dictionary = {"land": LAND_SFX, "jump" : JUMP_SFX,"side":JUMP_SIDE}
func play_prop(name: String) -> void:
	set_sprite_frames(Props[name])
	$sfx.set_stream(Sfxs[name])
	play()
	
func _on_animation_finished() -> void:
	queue_free()
func _enter_tree() -> void:
	$sfx.play()
