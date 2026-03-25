extends Path2D
class_name ShotPaths
@onready var wait: Timer = $wait
var started:= false
const FIRE_PROJECTILE = preload("res://scenes/misc/throwable/fire_projectile.tscn")
# Called when the nod enters the scene tree for the first time.
@onready var down_sound: AudioStreamPlayer = $downSound

var time:= 7
@onready var follow_2d: PathFollow2D = $follow2d
signal finished()
signal shooted(pos:Vector2)
@onready var spawn_timer: Timer = $spawnTimer

func start() -> void:
	started = true
	spawn_timer.start()
	wait.start()
func _ready() -> void:
	wait.wait_time = time
func _process(delta: float) -> void:
	follow_2d.progress_ratio = randf_range(0.0,0.99999)

func _on_spawn_timer_timeout() -> void:
	if started:
		down_sound.play()
		var new_shoot := FIRE_PROJECTILE.instantiate()
		add_child(new_shoot)
		new_shoot.set_new_position(Vector2(follow_2d.position))
		new_shoot.set_random_speed()
		new_shoot.set_direction(Vector2(0,1))
		emit_signal("shooted",new_shoot.position)
		
		
	
func _on_wait_timeout() -> void:
	started = false
	spawn_timer.stop()
	wait.stop()
	emit_signal("finished")
