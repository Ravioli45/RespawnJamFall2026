class_name DisplayDie
extends Panel

@export var min_spin_speed: int = 0
@export var max_spin_speed: int = 0
@export var dice_model: MeshInstance3D
@export var dice_face: MeshInstance3D
@export var modifier_display: Container

var rotation_speed = Vector3.ZERO

func _ready() -> void:
	rotation_speed = Vector3(randi_range(min_spin_speed, max_spin_speed), randi_range(min_spin_speed, max_spin_speed), randi_range(min_spin_speed, max_spin_speed))

func _process(delta: float) -> void:
	dice_model.rotation_degrees += rotation_speed * delta

func roll_animation():
	rotation_speed = Vector3(randi_range(min_spin_speed, max_spin_speed), randi_range(min_spin_speed, max_spin_speed), randi_range(min_spin_speed, max_spin_speed))
	dice_model.visible = true
	dice_face.visible = false
	
func show_face(data: FaceData):
	for child in modifier_display.get_children():
		child.queue_free()
	
	dice_face.mesh.material.albedo_texture = data.face_texture
	dice_model.visible = false
	dice_face.visible = true

	for m in ModifierTable.all:
		if data.modifiers & m != 0:
			var texture_rect := TextureRect.new()
			texture_rect.texture = ModifierTable.sprites[m]
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
			texture_rect.custom_minimum_size = Vector2(16, 16)
			modifier_display.add_child(texture_rect)
