extends CharacterBody2D
class_name Player
enum States {IDLE,RUN,JUMP,CROUCH,ATTACK,HURT,DEATH,ONSIDE}
var attack_anims: Array = ["attackA","attackC"]
var state: States = States.IDLE
const JUMP_SPEED: float = -3.8
const DAMAGE_JUMP: float = -90.0
var facing: int = -1
var sword_power: int = 1
var gems: int = 0
var score: int = 0
var air_attack: bool = false
var wall_jumped: bool = false
var can_wall_jump: bool = false
signal takeGem(amount: int)
signal takeLife(amount: int)
signal takeThrowable(type:int)
signal takePowerUp()
signal hurted(damage: int)
signal changeScore(amount : int)
@onready var standard_collision: CollisionShape2D = $standardCollision
@onready var crouch_collision: CollisionShape2D = $crouchCollision
@onready var floor_touch: RayCast2D = $floorTouch

@onready var crouch_ray: RayCast2D = $crouchRay

#sounds
const JUMP = preload("res://assets/sounds/jump.mp3")
#const ATTACK = preload("res://assets/sounds/attack.mp3")
const PLAYER_PROPS = preload("res://assets/misc/playerfx/playerProps.tscn")
const DEAD = preload("res://assets/sounds/player/dead.wav")
var counter: int = 0
#shoots
@export var SHOT :PackedScene
#knife and axe
const KNIFE_SHOT = preload("res://scripts/player_shots/knife_shot.tscn")
const AXE_SHOT = preload("res://scripts/player_shots/axe_shot.tscn")
#other
func desactivate() -> void:
	velocity = Vector2(0,0)
	change_state(States.IDLE)
	set_process(false)
func activate()->void:
	set_process(true)
func switch_collision() -> void:
	if not standard_collision.is_disabled():
		standard_collision.set_disabled(true)
		crouch_collision.set_disabled(false)
	else:
		if not crouch_collision.is_disabled():
			standard_collision.set_disabled(false)
			crouch_collision.set_disabled(true)
func _ready() -> void:
	set_process_mode(PROCESS_MODE_DISABLED)
	hide()
	$SpriteEntity.change_anim("idle")
	connect("takePowerUp", Callable(self, "pick_up_power"))
	connect("takeGem", Callable(self,"pick_up_gem"))
	connect("changeScore", Callable(self,"addScore"))
	connect("takeThrowable",func(type:int)->void:
		match type:
			1: SHOT = KNIFE_SHOT
			2: SHOT = AXE_SHOT
		)
func _process(delta: float) -> void:
	#print(str(gems))
	_update_state()
	#print(floor_touch.is_colliding())
	pass
func pick_up_gem(amount: int) -> void:
	if gems + amount < 100:
		gems += amount
	else:
		gems =  100
func pick_up_power() -> void:
	if sword_power < 2:
		sword_power += 1
func add_prop(name: String) -> void:
	var offset_x: int = 0
	var offset_y: int = 0
	var new_prop:=PLAYER_PROPS.instantiate() 
	new_prop.play_prop(name)
	if state==States.ONSIDE and $ActorBehavior.direction.x == -1:
		offset_x = -20
		offset_y =  10
	new_prop.position = to_global($SpriteEntity.position ) - Vector2(15+offset_x,-3+offset_y)
	get_parent().add_child(new_prop)
func add_score(amount: int) -> void:
	score += amount
	PlayerSingleton.score += amount
#movement functions
func start(pos:Vector2) -> void:
	position = pos
	show()
	set_process_mode(PROCESS_MODE_ALWAYS)
func side_movement() -> void:
	$ActorBehavior.direction.x = Input.get_axis("player_left","player_right")
	velocity.x = $ActorBehavior.get_velocity().x
	#feo, feisimo
	match $ActorBehavior.direction.x:
		1.0:
			facing = 1
			$SpriteEntity.flip_h = false
		-1.0:
			facing = -1
			$SpriteEntity.flip_h = true
func jump_movement() -> void:
	if Input.is_action_just_pressed("player_jump"):
		velocity.y = JUMP_SPEED * $ActorBehavior.speed
func crouch_movement() -> bool:
	if Input.is_action_pressed("player_crouch"):
		return true
	return false
func attack_movement() -> bool:
	if Input.is_action_just_pressed("player_attack"):
		$attackArea.activate(facing)
		return true
	return false
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
func play_run_sound() -> void:
	counter += 1
	if counter > 12:
		$movesound.play()
		counter = 0
func secondary_attack() -> void:
	if SHOT:
		if Input.is_action_just_pressed("player_attack2") and gems >= 2:
			velocity.x = 0
			
			emit_signal("takeGem", -2)
			var kn:PlayerShots=SHOT.instantiate()
			kn.mod_position(position)
			kn.mod_direction(facing)
			gems -= kn.gem_use
			get_parent().add_child(kn)
#fsm
func change_state(new_state: States) -> void:
	match state:
		States.IDLE:
			match new_state:
				States.RUN:
					$SpriteEntity.change_anim("run")
				States.JUMP:
					air_attack = false
					add_prop("jump")
					$sounds.set_stream(JUMP)
					$sounds.play()
					$SpriteEntity.change_anim("jump")
					
					#start_wall_jump_tm()
				States.CROUCH:
					switch_collision()
					$SpriteEntity.change_anim("crouch")
				States.ATTACK:
					#$sounds.set_stream(ATTACK)
					#$sounds.pitch_scale = randf_range(-0.9,1.7)
					$sounds.play()
					velocity.x = 0
					$SpriteEntity.change_anim(attack_anims[randi_range(0,1)])
		States.RUN:
			match new_state:
				States.IDLE:
					$SpriteEntity.change_anim("idle")
				States.JUMP:
					air_attack = false
					add_prop("jump")
					$sounds.set_stream(JUMP)
					$sounds.play()
					$SpriteEntity.change_anim("jump")
					
					#start_wall_jump_tm()
				States.CROUCH:
					switch_collision()
					velocity.x = 0
					$SpriteEntity.change_anim("crouch")
				States.ATTACK:
					#$sounds.set_stream(ATTACK)
					#$sounds.pitch_scale = randf_range(-0.9,1.7)
					$sounds.play()
					velocity.x = 0
					$SpriteEntity.change_anim(attack_anims[randi_range(0,1)])
		States.JUMP:
			match new_state:
				States.IDLE:
					#can_wall_jump = false
					$SpriteEntity.change_anim("idle")
					add_prop("land")
				States.RUN:
					$SpriteEntity.change_anim("run")
					add_prop("land")
				States.ATTACK:
					#can_wall_jump = false
					air_attack = true
					$SpriteEntity.change_anim("attackAir")
				States.ONSIDE:
					$SpriteEntity.change_anim("onside")
			
		States.CROUCH:
			match new_state:
				States.IDLE:
					switch_collision()
					$SpriteEntity.change_anim("idle")
				States.RUN:
					switch_collision()
					$SpriteEntity.change_anim("run")
		States.ATTACK:
			match new_state:
				States.IDLE:
					$SpriteEntity.change_anim("idle")
		States.HURT:
			$SpriteEntity.set_modulate(Color(1,1,1))
			$SpriteEntity.change_anim("idle")
		States.ONSIDE:
			match new_state:
				States.JUMP:
					add_prop("side")
					$sounds.set_stream(JUMP)
					$sounds.play()
					$SpriteEntity.change_anim("jump")
	if new_state == States.HURT:
		velocity = Vector2(velocity.x*-1, DAMAGE_JUMP)
		var tw:=create_tween().set_loops(5)
		tw.tween_callback(self.set_modulate.bind(Color(1,1,1,0))).set_delay(0.1)
		tw.tween_callback(self.set_modulate.bind(Color(1,1,1,1))).set_delay(0.1)
		$hurtSound.play()
		#$SpriteEntity.set_modulate(Color(1,0,0))
		$SpriteEntity.change_anim("hurt")
	if new_state == States.DEATH:
		velocity = Vector2(0,0)
		$SpriteEntity.change_anim("death")
		set_process(false)
	state = new_state
func _update_state() -> void:
	match state:
		States.IDLE:
			side_movement()
			jump_movement()
			attack_movement()
			secondary_attack()
			if velocity.x != 0:
				change_state(States.RUN)
			if velocity.y != 0:
				change_state(States.JUMP)
			if crouch_movement():
				change_state(States.CROUCH)
			if attack_movement():
				change_state(States.ATTACK)
		States.RUN:
			play_run_sound()
			side_movement()
			jump_movement()
			attack_movement()
			secondary_attack()
			if crouch_movement():
				change_state(States.CROUCH)
			if is_zero_approx(velocity.x):
				change_state(States.IDLE)
			if velocity.y != 0:
				change_state(States.JUMP)
			if attack_movement():
				change_state(States.ATTACK)
		States.JUMP:
			if not wall_jumped:
				side_movement()
			secondary_attack()
			if velocity.y > 0:
				$SpriteEntity.change_anim("fall")
			if not air_attack and attack_movement():
				change_state(States.ATTACK)
			if is_on_floor():
				wall_jumped = false
				if velocity.x != 0:
					change_state(States.RUN)
				else:
					change_state(States.IDLE)
			if is_on_wall_only() and not floor_touch.is_colliding():
				change_state(States.ONSIDE)
		States.CROUCH:
			
			if not crouch_ray.is_colliding():
				if velocity.x != 0:
					change_state(States.RUN)
				if not crouch_movement():
					change_state(States.IDLE)
			else:
				side_movement()
		States.ATTACK:
			if velocity.y != 0:
				side_movement()
			if not $attackArea.is_actived():
				if velocity.y != 0:
					change_state(States.JUMP)
				else:
					change_state(States.IDLE)
		States.HURT:
			if is_on_floor():
				change_state(States.IDLE)
		States.ONSIDE:
			wall_jumped = wall_jump()
			if $ActorBehavior.direction.x*-1 != get_wall_normal().x or is_on_floor():
				change_state(States.JUMP)

func _on_hurted(damage: int) -> void:
	change_state(States.HURT)


func _on_life_component_life_depleted() -> void:
	change_state(States.DEATH)
	$attackArea.desactivate()
	set_collision_mask_value(3,false)
	$sounds.set_stream(DEAD)
	$sounds.play()
	var tween:= create_tween()
	tween.tween_property(self,"modulate",Color(0,0,0),2)
	await get_tree().create_timer(5).timeout
	get_tree().reload_current_scene()
func start_wall_jump_tm() -> void:
	await get_tree().create_timer(.5).timeout
	can_wall_jump = true
func wall_jump() -> bool:
	if Input.is_action_just_pressed("player_jump"):
		
		$ActorBehavior.direction.x = get_wall_normal().x
		velocity.x = $ActorBehavior.get_velocity().x
		velocity.y = JUMP_SPEED*90
		match $ActorBehavior.direction.x:
			1.0:
				facing = 1
				$SpriteEntity.flip_h = false
			-1.0:
				facing = -1
				$SpriteEntity.flip_h = true
		return true
	return false
