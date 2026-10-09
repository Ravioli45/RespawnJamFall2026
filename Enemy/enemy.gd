extends CharacterBody3D

@export var body: MeshInstance3D
@export var frozen_material:  StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	freeze()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func freeze() -> void:
	#TODO pause animation
	if not frozen_material:
		return
	body.material_override = frozen_material
