class_name Player
extends CharacterBody3D

signal player_died

@export var interact_raycast: RayCast3D

@export_subgroup("Movement")
@export var head: Node3D
@export var speed: float = 0
@export var jump_strength: float = 0
@export var mouse_sensitivity: float = 0

@export_subgroup("Weapon")
@export var weapon: Shotgun

@export_subgroup("Dice")
@export var dice_grid: DiceGrid

func _ready() -> void:
	#dice_grid.show_faces(weapon.current_faces)
	for f in weapon.current_faces:
		dice_grid.add_dice(f)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		event = event as InputEventMouseMotion
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clampf(head.rotation.x, -deg_to_rad(90), deg_to_rad(90))
	elif event.is_action_pressed("shoot") and is_instance_valid(weapon):
		weapon.shoot()
		dice_grid.roll_all()
	elif event.is_action_pressed("interact") and is_instance_valid(interact_raycast):
		# print("p")
		var interactable := interact_raycast.get_collider()
		if interactable is SlotMachine:
			interactable.interact()

func _physics_process(delta: float) -> void:
	var target_velocity = Vector3(0, velocity.y, 0)

	if !is_on_floor():
		target_velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("jump"):
		target_velocity.y += jump_strength
	else:
		target_velocity.y = 0

	var input_vector: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	
	var move_vector: Vector3  = speed * (transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()	
	target_velocity.x =  move_vector.x
	target_velocity.z = move_vector.z

	velocity = target_velocity

func _on_died() -> void:
	print("player died")
	player_died.emit()

func _on_health_changed(old_health: Variant, new_health: Variant) -> void:
	print("player took " + str(old_health - new_health) + " damage")
	# TODO: replace with player take damage logic

func _on_reloaded():
	print("reloaded")
	#print(weapon.current_faces)
	dice_grid.show_faces(weapon.current_faces)
	pass
