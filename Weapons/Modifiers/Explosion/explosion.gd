extends Node3D

func _ready() -> void:
	$Explosion.emitting = true

func _on_explosion_finished() -> void:
	call_deferred("queue_free")
