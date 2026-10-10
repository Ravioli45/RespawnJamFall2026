class_name HitboxComponent
extends Area3D

signal hit(hurtbox: HurtboxComponent)

@export var damage: int = 1

func on_hit(hurtbox: HurtboxComponent):
	# print("hit")
	hit.emit(hurtbox)

func _on_area_entered(area: Area3D) -> void:
	print("hitbox area entered")
	
	if area is HurtboxComponent:
		area = area as HurtboxComponent
		
		hit.emit(area)
		area.on_hurt(self)
	#pass # Replace with function body.wa
