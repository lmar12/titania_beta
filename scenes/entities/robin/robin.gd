extends CharacterBody2D
signal take_damage(amount: int)
const EXPLOSION = preload("res://assets/fx/explosion/explosion.tscn")
func _ready()->void:
	pass
	#set_attack_anim()
func set_attack_anim()-> void:
	$SpriteEntity.change_anim("attack")
func set_idle_anim() -> void:
	$SpriteEntity.change_anim("idle")
func death() -> void:
	var new_explosion = EXPLOSION.instantiate()
	new_explosion.position = Vector2(position)
	get_parent().add_child(new_explosion)
	queue_free()
func damage(amount: int):
	$LifeComponent.take_damage(amount)
	print("Actual Life:"+str($LifeComponent.current_life))
	
	$SpriteEntity.set_modulate(Color.CRIMSON)
	await(get_tree().create_timer(0.2).timeout)
	$SpriteEntity.set_modulate(Color.WHITE)
