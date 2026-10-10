extends CharacterBody3D

enum EnemyState{
	Running,
	Attacking,
	Hurt
}

@export var body: MeshInstance3D
@export var frozen_material:  StandardMaterial3D
@export var poison_particles: GPUParticles3D

@export var player: Player
@export var speed: float = 1
@export var navigation_agent: NavigationAgent3D

@export var hitbox: HitboxComponent
@export var coin_scene: PackedScene

var state: EnemyState = EnemyState.Running

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print(state)
	var target_velocity = Vector3(0, velocity.y, 0)
	
	if !is_on_floor():
		target_velocity += get_gravity() * delta
	else:
		target_velocity.y = 0
	
	match state:
		EnemyState.Running:
			if is_instance_valid(player):
				#print('p')
				navigation_agent.target_position = player.global_position
				var next_position := navigation_agent.get_next_path_position()
				#print(navigation_agent.get_next_path_position())
				if not navigation_agent.is_target_reached():
					var direction_to: Vector3 = global_position.direction_to(next_position)
					var target_direction: Vector2 = Vector2(direction_to.x, direction_to.z)
					#print(target_direction)
					rotation.y = atan2(-target_direction.y, target_direction.x)
					var nav_velocity := transform.basis.x.normalized() * speed
					target_velocity.x = nav_velocity.x
					target_velocity.z = nav_velocity.z
			
			# for body in hitbox.get_overlapping_bodies():
				# pass
			
		EnemyState.Attacking, EnemyState.Hurt:
			target_velocity.x = 0
			target_velocity.y = 0
	"""
	if is_instance_valid(player):
		#print('p')
		navigation_agent.target_position = player.global_position
		var next_position := navigation_agent.get_next_path_position()
		#print(navigation_agent.get_next_path_position())
		if not navigation_agent.is_target_reached():
			var direction_to: Vector3 = global_position.direction_to(next_position)
			var target_direction: Vector2 = Vector2(direction_to.x, direction_to.z)
			#print(target_direction)
			rotation.y = atan2(-target_direction.y, target_direction.x)
			var nav_velocity := transform.basis.x.normalized() * speed
			target_velocity.x = nav_velocity.x
			target_velocity.z = nav_velocity.z
	"""
	
	velocity = target_velocity

func freeze() -> void:
	#TODO pause animation
	if not frozen_material:
		return
	body.material_override = frozen_material

func get_poisoned() -> void:
	if not poison_particles:
		return
	poison_particles.emitting = true


func _on_died() -> void:
	print("enemy died")
	var coins_dropped := randi_range(1, 3)
	
	for i in range(coins_dropped):
		var new_coin := coin_scene.instantiate() as Coin
		get_parent().add_child(new_coin)
		new_coin.global_position = global_position

		new_coin.global_position.x += randf_range(-0.1, 0.1)
		new_coin.global_position.z += randf_range(-0.1, 0.1)
	
	call_deferred("queue_free")


func _on_hurt() -> void:
	print("enemy hurt")
	state = EnemyState.Hurt
	pass # Replace with function body.


func _on_hit(_hurtbox: HurtboxComponent) -> void:
	state = EnemyState.Attacking

func _on_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "Hurt" or anim_name == "Attack":
		state = EnemyState.Running
		hitbox.monitoring = false
		await get_tree().physics_frame
		await get_tree().physics_frame
		hitbox.monitoring = true
	pass # Replace with function body.
