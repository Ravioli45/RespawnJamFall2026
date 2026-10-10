class_name Shotgun
extends Node3D

signal reloaded

@export var reload_timer: Timer
@export var animation_player: AnimationPlayer
@export var muzzle_particles: GPUParticles3D

@export_subgroup("Projectile")
@export var projectile_spawn_position: Node3D
@export var projectile: PackedScene
@export var spread: float = 0

@export_subgroup("Dice")
@export var dice_data: Array[DieData]
@export var default_dice: DieData
# @export var dice_count: int = 1

var current_faces: Array[FaceData]
var can_shoot: bool = false

func _ready() -> void:
	choose_faces()
	can_shoot = true

func shoot() -> void:
	# print("pew pew")

	if projectile and projectile_spawn_position and can_shoot:
		animation_player.play("Reload")
		muzzle_particles.emitting = true
		
		for face in current_faces:
			var new_projectile = projectile.instantiate() as DieBullet
			get_parent().get_parent().get_parent().add_child(new_projectile)
			new_projectile.global_position = projectile_spawn_position.global_position
			new_projectile.global_rotation = projectile_spawn_position.global_rotation

			var rand_angle = randf() * TAU
			var rand_dist = randf() * spread
			var offset = Vector2.from_angle(rand_angle).normalized() * rand_dist
			var relative_offset = new_projectile.transform.basis * Vector3(offset.x, offset.y, 0)
			new_projectile.global_position += relative_offset

			new_projectile.modifiers = face.modifiers
			new_projectile.damage = face.value

		can_shoot = false
		if is_instance_valid(reload_timer):
			reload_timer.start()

func choose_faces() -> void:
	current_faces.clear()
	for die in dice_data:
		current_faces.append(die.faces.pick_random())

func _on_reload_timeout() -> void:
	choose_faces()
	reloaded.emit()
	can_shoot = true
