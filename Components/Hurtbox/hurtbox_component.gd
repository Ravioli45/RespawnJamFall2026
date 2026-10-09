class_name HurtboxComponent
extends Area3D

signal hurt

@export var health: HealthComponent

func _on_area_entered(area: Area3D) -> void:
	hurt.emit()
	
	if is_instance_valid(health) and area is HitboxComponent:
		var hitbox = area as HitboxComponent
		health.take_damage(hitbox.damage)
		hitbox.on_hit()
