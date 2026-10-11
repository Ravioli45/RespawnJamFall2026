class_name LevelManager
extends Node3D

@export var player: Player
@export var enemy_spawn_points: Array[Marker3D]
@export var enemy_packed_scene: PackedScene

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func spawn_enemy() -> void:
	if not enemy_packed_scene:
		print("Error, no enemy packed scene")
		return
	var new_enemy = enemy_packed_scene.instantiate()
	var selected_spawn_position: Vector3 = enemy_spawn_points[randi() % 6].position
	new_enemy.position = selected_spawn_position
	new_enemy.player = player
	add_child(new_enemy)
