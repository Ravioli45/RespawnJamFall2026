extends Node

var kill_count: int = 0
var time_alive: float = 0.0
var max_kills: int = 0;

func increase_kills() -> void:
	print(kill_count)
	kill_count += 1
	if(kill_count > max_kills):
		max_kills = kill_count
