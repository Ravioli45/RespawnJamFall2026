extends Control

func _ready() -> void:
	KillCounter.kill_count = 0

func play() -> void:
	get_tree().change_scene_to_file('uid://d3ww4g1s5k58m')
