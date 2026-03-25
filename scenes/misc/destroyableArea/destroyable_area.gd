extends Area2D
enum Types {GEM,POWERUP}
@export var type: Types
@export var score: int
@export_group("Item")
@export var throw_items: bool = false
const IMPACT = preload("res://assets/fx/impact.tres")
const GEM = preload("res://scenes/items/gem.tscn")
const POWER_UP = preload("res://scenes/misc/items/powerUp.tscn")
var item: PackedScene
signal destroy()
func _ready() -> void:
	match type:
		Types.GEM:
			item = 	GEM
		Types.POWERUP:
			item = POWER_UP
func _on_destroy() -> void:
	$CollisionShape2D.set_disabled(true)
	var new_item := item.instantiate()
	new_item.move(position)
	get_parent().add_child(new_item)
	$AnimatedSprite2D.set_sprite_frames(IMPACT)
	$AnimatedSprite2D.play()
	$sfx.play()
	var t:=create_tween()
	t.tween_property(self,"position",position+Vector2(0,10),1)
	t.set_parallel()
	t.tween_property(self,"scale", scale + Vector2(1,1),1)
func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
