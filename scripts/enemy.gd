extends CharacterBody2D
signal take_damage(amount: int)
const EXPLOSION = preload("res://assets/fx/explosion/explosion.tscn")
const FRUGAL_SOUND = preload("res://assets/sounds/frugal_sound.tscn")
#var target: Player
@export var score: int
@export_subgroup("Death")
@export var death_color: Color = Color.WHITE
@export var explosion_scale: Vector2 = Vector2(1,1)

@export var death_audio = AudioStream
@onready var target: Player = get_tree().get_nodes_in_group("player")[0]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	pass
	#target = get_tree().get_nodes_in_group("player")[0]
func _process(delta: float) -> void:
	pass
func _on_life_depleted() -> void:
	set_visible(false)
	$EnemyArea.emit_signal("desactivate")
	$CollisionShape2D.set_disabled(true)
	var new_explosion = EXPLOSION.instantiate()
	target.emit_signal("changeScore", score)
	new_explosion.config(Vector2(position), death_color, explosion_scale)
	get_parent().add_child(new_explosion)
	var new_sound := FRUGAL_SOUND.instantiate()
	new_sound.set_stream(death_audio)
	new_sound.play()
	queue_free()
func distace_to_target() -> float:
	return position.distance_to(target.position)
func seek() -> void:
	var pos_x:= target.position.x
	if position.x < pos_x:
		$ActorBehavior.direction.x = -1.0
	if position.x > pos_x:
		$ActorBehavior.direction.x =  1.0
func seek2() -> void: #mejora esta mierda!!!!!!!!!
	var angle := position.angle_to_point(target.position)
	var new_direction: float = $ActorBehavior.direction.x
	if angle >= PI/2 and angle < PI:
		new_direction  = -1.0
	else:
		new_direction  =  1.0
	match new_direction:
		1.0:
			$SpriteEntity.set_flip_h(true)
		-1.0:
			$SpriteEntity.set_flip_h(false)
	$ActorBehavior.direction.x = new_direction
