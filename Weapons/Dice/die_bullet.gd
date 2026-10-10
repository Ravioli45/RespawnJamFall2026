class_name DieBullet
extends CharacterBody3D

@export var speed: float = 1
@export_flags("Explosive", "Freezing") var modifiers: int
@export var dice_model: MeshInstance3D

var rotation_speed = Vector3.ZERO
@export var damage: int = 0:
	set(new_value):
		damage = new_value
		$HitboxComponent.damage = damage

func _ready() -> void:
	rotation_speed = Vector3(randi_range(150, 300), randi_range(150, 300), randi_range(150, 300))
	dice_model.rotation_degrees = Vector3(randi_range(0, 360), randi_range(0, 360), randi_range(0, 360))

func _process(delta: float) -> void:
	dice_model.rotation_degrees += rotation_speed * delta

func _physics_process(_delta: float) -> void:
	velocity = -transform.basis.z.normalized() * speed

func _on_hit(hurtbox: HurtboxComponent) -> void:
	print("dice hit something for " + str(damage) + " damage")

	#if modifiers & ModifierTable.ModifierFlags.Explosive != 0:
		#ModifierTable.modifiers[ModifierTable.ModifierFlags.Explosive].call(self)

	for m in ModifierTable.all:
		if m & modifiers != 0:
			ModifierTable.modifiers[m].call(self, hurtbox)
	
	call_deferred("queue_free")
