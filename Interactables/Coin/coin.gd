class_name Coin
extends Node3D

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
		queue_free()
