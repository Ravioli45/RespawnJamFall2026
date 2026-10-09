class_name DieBullet
extends CharacterBody3D

@export var speed: float = 1
@export_flags("Explosive", "Freezing") var modifiers: int

@export var damage: int = 0:
	set(new_value):
		damage = new_value
		$HitboxComponent.damage = damage

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
