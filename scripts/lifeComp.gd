extends Node
class_name LifeComponent
@export_range(0,100) var max_life: int = 0
@onready var current_life:int = max_life
signal life_depleted
signal damage(amount: int)
signal life(amount: int)
func take_damage(amount: int) -> void:
	if current_life != 0:
		current_life -= amount
		if current_life < 1:
			current_life = 0
			emit_signal("life_depleted")
func take_life(amount: int) -> void:
	current_life += amount
	if current_life > max_life:
		current_life = max_life
func set_life(max: int) -> void:
	self.max_life = max
	self.current_life = max
	
