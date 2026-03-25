extends CharacterBody2D
signal take_damage(amount: int)
const EXPLOSION = preload("res://assets/fx/explosion/explosion.tscn")
func damage(amount: int):
	$LifeComponent.take_damage(amount)
	
	print("Actual Life:"+str($LifeComponent.current_life))
	$SpriteEntity.set_modulate(Color.CRIMSON)
	await(get_tree().create_timer(0.2).timeout)
	$SpriteEntity.set_modulate(Color.WHITE)
func death() -> void:
	set_visible(false)
	var new_explosion = EXPLOSION.instantiate()
	new_explosion.position = Vector2(position)
	new_explosion.set_modulate(Color.GREEN_YELLOW)
	get_parent().add_child(new_explosion)
	$dieSound.play()
	await($dieSound.finished)
	queue_free()
