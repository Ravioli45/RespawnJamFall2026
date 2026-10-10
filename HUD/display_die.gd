class_name DisplayDie
extends PanelContainer

@export var min_spin_speed: int = 0
@export var max_spin_speed: int = 0
@export var dice_model: MeshInstance3D
@export var dice_face: MeshInstance3D

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
	dice_face.mesh.material.albedo_texture = data.face_texture
	dice_model.visible = false
	dice_face.visible = true
