class_name HurtboxComponent
extends Area3D

signal hurt

@export var health: HealthComponent

func _on_area_entered(area: Area3D) -> void:
	# print("hurt")
	hurt.emit()
	
	if area is HitboxComponent:
		var hitbox = area as HitboxComponent
		if is_instance_valid(health):
			health.take_damage(hitbox.damage)
		#health.take_damage(hitbox.damage)
		hitbox.on_hit(self)
