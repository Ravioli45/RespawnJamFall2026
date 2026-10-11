extends AudioStreamPlayer3D

func _die() -> void:
	print("TEST")
	call_deferred("queue_free")
