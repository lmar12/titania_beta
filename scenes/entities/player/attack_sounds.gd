extends AudioStreamPlayer
const MISS_1 = preload("res://assets/sounds/player/attackSounds/27_sword_miss_1.wav")
const MISS_2 = preload("res://assets/sounds/player/attackSounds/27_sword_miss_2.wav")
const MISS_3 = preload("res://assets/sounds/player/attackSounds/27_sword_miss_3.wav")

const HIT_1 = preload("res://assets/sounds/player/attackSounds/26_sword_hit_1.wav")
const HIT_2 = preload("res://assets/sounds/player/attackSounds/26_sword_hit_2.wav")
const HIT_3 = preload("res://assets/sounds/player/attackSounds/26_sword_hit_3.wav")

signal hitted()
signal missed()

var miss_sounds: Array = [MISS_1,MISS_2,MISS_3]
var hit_sounds: Array = [HIT_1,HIT_2,HIT_3]


func _on_hitted() -> void:
	set_stream(miss_sounds.pick_random())
	play()


func _on_missed() -> void:
	set_stream(hit_sounds.pick_random())
	play()
