extends CharacterBody3D

@export var speed: float = 1

func _physics_process(_delta: float) -> void:
	velocity = -transform.basis.z.normalized() * speed

func _on_hit() -> void:
	# print("dice hit something")
	call_deferred("queue_free")
