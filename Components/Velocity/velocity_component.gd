class_name VelocityComponent
extends Node

@export var target: CharacterBody3D;
# var target_velocity: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if is_instance_valid(target):
		target.move_and_slide()
