class_name Enemy
extends CharacterBody3D

signal enemy_killed

enum EnemyState{
	Running,
	Attacking,
	Hurt,
	Dead,
	Frozen
}

@export var body: MeshInstance3D
@export var frozen_material:  StandardMaterial3D
@export var freeze_timer: Timer
@export var poison_particles: GPUParticles3D
@export var poison_timer: Timer
@export var poison_tick_timer: Timer

@export var health_component: HealthComponent

@export var player: Player
@export var speed: float = 1
@export var navigation_agent: NavigationAgent3D
@export var animation_tree: AnimationTree

@export var hitbox: HitboxComponent
@export var coin_scene: PackedScene

@export var hurt_sound: AudioStreamPlayer3D
@export var attack_sound: AudioStreamPlayer3D
@export var walk_sound: AudioStreamPlayer3D
@export var freeze_sound: AudioStreamPlayer3D
@export var poison_sound: AudioStreamPlayer3D
@export var dead_scene: PackedScene

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
			
		EnemyState.Attacking, EnemyState.Hurt, EnemyState.Dead, EnemyState.Frozen:
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
	
	if target_velocity.x >= 0.05 or target_velocity.z >= 0.05:
		if not walk_sound.playing:
			walk_sound.play()
	else:
		walk_sound.stop()
	
	velocity = target_velocity

func freeze() -> void:
	#TODO pause animation
	if not frozen_material:
		return
	
	body.material_override = frozen_material
	
	if state != EnemyState.Dead:
		state = EnemyState.Frozen
		if not freeze_sound.playing:
			freeze_sound.play()
		freeze_timer.start()
	
func get_poisoned() -> void:
	if not poison_particles:
		return
	if not poison_sound.playing:
		poison_sound.play()
	poison_particles.emitting = true
	poison_tick_timer.start()
	poison_timer.start()


func _on_died() -> void:
	print("enemy died")
	enemy_killed.emit()
	var coins_dropped := randi_range(1, 3)
	
	for i in range(coins_dropped):
		var new_coin := coin_scene.instantiate() as Coin
		get_parent().add_child(new_coin)
		new_coin.global_position = global_position

		new_coin.global_position.x += randf_range(-0.1, 0.1)
		new_coin.global_position.z += randf_range(-0.1, 0.1)
	
	var dead_sound = dead_scene.instantiate()
	get_parent().add_child(dead_sound)
	dead_sound.global_position = global_position
	dead_sound.play()
	
	call_deferred("kill")
	#state = EnemyState.Dead

func kill() -> void:
	state = EnemyState.Dead
	hitbox.monitoring = false


func _on_hurt() -> void:
	print("enemy hurt")
	if state == EnemyState.Frozen:
		return
	
	if not hurt_sound.playing:
		hurt_sound.play()
	
	state = EnemyState.Hurt
	pass # Replace with function body.


func _on_hit(_hurtbox: HurtboxComponent) -> void:
	if state == EnemyState.Frozen:
		return
	
	if not attack_sound.playing:
		attack_sound.play()
	state = EnemyState.Attacking

func _on_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if (anim_name == "Hurt" or anim_name == "Attack" or anim_name == "Idle") and state != EnemyState.Dead:
		state = EnemyState.Running
		hitbox.monitoring = false
		await get_tree().physics_frame
		await get_tree().physics_frame
		hitbox.monitoring = true
	elif anim_name == "Death_001":
		queue_free()
	pass # Replace with function body.


func _on_freeze_timeout() -> void:
	body.material_override = null
	if state != EnemyState.Dead:
		state = EnemyState.Running
		hitbox.monitoring = false
		await get_tree().physics_frame
		await get_tree().physics_frame
		hitbox.monitoring = true
		
	#pass # Replace with function body.


func _on_poison_timout() -> void:
	poison_particles.emitting = false
	poison_tick_timer.stop()
	pass # Replace with function body.


func _on_poison_tick_stimeout() -> void:
	health_component.take_damage(5)
	pass # Replace with function body.


func _on_death_sound_finished() -> void:
	pass # Replace with function body.
