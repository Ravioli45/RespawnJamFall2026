class_name HitboxComponent
extends Area3D

signal hit(hurtbox: HurtboxComponent)

@export var damage: int = 1

func on_hit(hurtbox: HurtboxComponent):
	# print("hit")
	hit.emit(hurtbox)
