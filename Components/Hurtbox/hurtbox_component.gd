class_name HurtboxComponent
extends Area3D

signal hurt

@export var health: HealthComponent

func on_hurt(hitbox: HitboxComponent):
	hurt.emit()
	
	if is_instance_valid(health):
		health.take_damage(hitbox.damage)
