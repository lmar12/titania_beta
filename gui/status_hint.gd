extends HBoxContainer
@onready var default_bar: TextureProgressBar = $defaultBar
func _set_life(amount:int) -> void:
	default_bar.value = amount
func _update_life(amount: int) -> void:
	default_bar.set_value_no_signal(default_bar.value+amount)
