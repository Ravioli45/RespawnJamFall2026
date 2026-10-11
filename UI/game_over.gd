extends Control

@export var kill_label: Label
@export var time_label: Label

func _ready() -> void:
	kill_label.text = "Kill Count: " + str(KillCounter.kill_count)
	
	var time_alive = KillCounter.time_alive
	
	var seconds = str(floori(fmod(time_alive, 60.0))).pad_zeros(2)
	time_label.text = "Run Time: " + str(floori(time_alive / 60)) + ":" + seconds

func play() -> void:
	KillCounter.kill_count = 0
	KillCounter.time_alive = 0
	get_tree().change_scene_to_file('uid://d3ww4g1s5k58m')
