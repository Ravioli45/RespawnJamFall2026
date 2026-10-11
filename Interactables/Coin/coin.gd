class_name Coin
extends Node3D

@export var collision_area: Area3D
@export var coin_audio: AudioStreamPlayer3D
@export var rotation_speed: float = 0

func _ready() -> void:
	rotation.y = randf_range(0, TAU) 

func _physics_process(delta: float) -> void:
	rotate_y(rotation_speed * delta)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		print("coin picked up by player")
		body = body as Player
		body.coins += 1
		# call_deferred("queue_free")
		#collision_area.monitoring = false
		collision_area.set_deferred("monitoring", false)
		visible = false
		coin_audio.play()
		#queue_free()


func _on_audio_finished() -> void:
	call_deferred("queue_free")
	pass # Replace with function body.
