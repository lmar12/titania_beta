extends Node
var last_init_position:=Vector2(72,160)
var score:int=0
var life_rest:=3
var current_level := 0
func next_level()->void:
	current_level += 1
	match current_level:
		1: get_tree().change_scene_to_file("res://scenes/level/level1-1.tscn")
		2: get_tree().change_scene_to_file("res://scenes/level/boss_level1/boss_level_1.tscn")
		3: get_tree().change_scene_to_file("res://scenes/end_canvas.tscn")
