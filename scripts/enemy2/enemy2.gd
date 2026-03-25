extends Area2D
signal takeDamage(a:int)
@onready var sprite: AnimatedSprite2D = $sprite
@onready var shape: CollisionShape2D = $shape
@onready var sfx: AudioStreamPlayer = $sfx

@export_range(1.0,100.0) var speed: float = 0.0
@export var damage_given = 1
@export var score: int = 0
@export var target: Player
@export_group("GravityArea")
@export var apply_gravity:= false
@export_range(3.0,10.0) var gravity_scale = 3.0
@export_group("Sounds")
@export var hit_sound: AudioStream
@export var death_sound: AudioStream
var direction_x = -1 
const SCORE_LABEL = preload("res://gui/score_label.tscn")

const EXPLOSION = preload("res://assets/fx/explosion/explosion.tscn")
const HURT = preload("res://assets/sounds/hurt.wav")
const DEATH_DEFAULT = preload("res://assets/sounds/deathDefault.wav")
func _ready() -> void:
	if not target:
		target = get_tree().get_nodes_in_group("player")[0]
	if not hit_sound:
		hit_sound = HURT
	if not death_sound:
		death_sound = DEATH_DEFAULT
func _process(delta: float) -> void:
	if position.y > 3000:
		queue_free()
	pass

func play_hit_sound(a:int) -> void:
	sfx.set_stream(hit_sound)
	sfx.play()
func play_death_sound() -> void:
	set_collision_mask_value(2,false)
	sfx.set_stream(death_sound)
	sfx.play()
func _on_life_life_depleted() -> void:
	sprite.set_visible(false)
	shape.set_disabled(true)
	#explosion
	play_death_sound()
	var new_exp:=EXPLOSION.instantiate()
	new_exp.config(Vector2(position)+Vector2(0,-10),Color(1,1,1),Vector2(0.7,0.7))
	get_parent().add_child(new_exp)
	#score
	var new_score:=SCORE_LABEL.instantiate()
	new_score.set_score(str(score))
	new_score.set_position(Vector2(position.x-5,position.y-7))
	get_parent().add_child(new_score)
	#queue_free
	await sfx.finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("hurted", damage_given)
func distance_to_target() -> float:
	if target:
		return position.distance_to(target.position)
	return 0.0
func check_target_direction() -> float:
	var rt := 0.0
	if target:
		var x1 = target.position.x
		var x2 = position.x
		if x2 > x1: rt=-1.0
		if x2 < x1: rt= 1.0
	return rt
func _physics_process(delta: float) -> void:
	if apply_gravity:
		position.y += (get_gravity()/gravity_scale) * delta
func set_hurt_sprite(a:int) -> void:
	modulate = Color(Color.DARK_RED)
	await get_tree().create_timer(0.2).timeout
	modulate = Color(Color.WHITE)
