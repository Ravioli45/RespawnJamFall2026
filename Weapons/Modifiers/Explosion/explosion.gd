extends Node3D

@export var explosion_scene: PackedScene

func _ready() -> void:
	var explosion_sound = explosion_scene.instantiate()
	get_parent().add_child(explosion_sound)
	explosion_sound.global_position = global_position
	explosion_sound.play()
	$Explosion.emitting = true
	

func _on_explosion_finished() -> void:
	call_deferred("queue_free")
