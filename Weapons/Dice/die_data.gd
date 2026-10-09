class_name DieData
extends Resource

@export var faces: Array[FaceData]

func _init(p_faces: Array[FaceData] = []) -> void:
	faces = p_faces
