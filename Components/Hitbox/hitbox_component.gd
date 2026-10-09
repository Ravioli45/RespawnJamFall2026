class_name HitboxComponent
extends Area3D

signal hit

@export var damage: int = 1

func on_hit():
	hit.emit()
