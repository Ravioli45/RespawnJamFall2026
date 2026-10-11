class_name LevelManager
extends Node3D

@export var player: Player
@export var enemy_spawn_points: Array[Marker3D]
@export var enemy_packed_scene: PackedScene
@export var pause_menu: ColorRect

func _ready() -> void:
	var startingEnemies: int = 1
	for i in startingEnemies:
		spawn_enemy()
		
	capture_mouse()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		release_mouse()
		if pause_menu:
			pause_menu.show()

func spawn_enemy() -> void:
	if not enemy_packed_scene:
		print("Error, no enemy packed scene")
		return
	var new_enemy = enemy_packed_scene.instantiate()
	var selected_spawn_position: Vector3 = enemy_spawn_points[randi() % 6].position
	new_enemy.position = selected_spawn_position
	new_enemy.player = player
	new_enemy.enemy_killed.connect(increase_kill_count)
	add_child(new_enemy)

func end_game() -> void:
	release_mouse()
	get_tree().call_deferred("change_scene_to_file", "uid://c2waut6v2tex6")

func capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func release_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func increase_kill_count() -> void:
	KillCounter.increase_kills()
