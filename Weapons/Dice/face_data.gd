class_name FaceData
extends Resource

@export var value: int
@export_flags("Explosive", "Freezing") var modifiers: int
@export var face_texture: Texture2D

func _init(p_value = 0, p_modifiers = 0, p_face_texture = null) -> void:
	value = p_value
	modifiers = p_modifiers
	face_texture = p_face_texture

func _to_string() -> String:
	return "FaceData: " + str(value)

func add_modifiers(flags: ModifierTable.ModifierFlags):
	modifiers |= flags
