extends Object
class_name AudioPool
var audio_pool: Dictionary
var current: AudioStreamPlayer
func _add_audio(stream: AudioStreamPlayer, name: String):
	audio_pool.get_or_add(name, stream)
func _play_sound(name: String) -> void:
	if audio_pool.has(name):
		current = audio_pool[name]
		current.play()
	
