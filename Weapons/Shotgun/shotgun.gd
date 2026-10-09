class_name Shotgun
extends Node3D

@export var projectile_spawn_position: Node3D
@export var projectile: PackedScene

func shoot() -> void:
	# print("pew pew")

	if projectile and projectile_spawn_position:
		var new_projectile = projectile.instantiate() as Node3D
		get_parent().get_parent().get_parent().add_child(new_projectile)
		new_projectile.global_position = projectile_spawn_position.global_position
		new_projectile.global_rotation = projectile_spawn_position.global_rotation

