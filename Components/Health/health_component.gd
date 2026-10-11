class_name HealthComponent
extends Node

signal died
signal health_changed(old_health: int, new_health: int)

@export var health: int = 10

func take_damage(damage: int):
	health -= damage

	health_changed.emit(health + damage, health)

	if health <= 0 and health + damage > 0:
		died.emit()
