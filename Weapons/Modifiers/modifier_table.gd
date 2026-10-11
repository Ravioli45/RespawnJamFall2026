extends Node

@export var explosion_scene: PackedScene
@export var explosion_sprite: Texture2D
@export var freeze_sprite: Texture2D
@export var poison_sprite: Texture2D

enum ModifierFlags{
	Explosive = 1 << 0,
	Freezing = 1 << 1,
	Poison = 1 << 2,
}

var all: Array[ModifierFlags] = [ModifierFlags.Explosive, ModifierFlags.Freezing, ModifierFlags.Poison]

var modifiers: Dictionary[ModifierFlags, Callable]
var sprites: Dictionary[ModifierFlags, Texture2D]

func _ready() -> void:
	modifiers[ModifierFlags.Explosive] = explosive_affect
	modifiers[ModifierFlags.Freezing] = freeze_effect
	modifiers[ModifierFlags.Poison] = poison_effect
	
	sprites[ModifierFlags.Explosive] = explosion_sprite
	sprites[ModifierFlags.Freezing] = freeze_sprite
	sprites[ModifierFlags.Poison] = poison_sprite

# all effects will need this same function signature
func explosive_affect(bullet: Node3D, hurtbox: HurtboxComponent) -> void:
	print("explosion effect")
	var new_explosion = explosion_scene.instantiate()
	bullet.get_parent().add_child(new_explosion)
	new_explosion.global_position = bullet.global_position
	
func freeze_effect(bullet: Node3D, hurtbox: HurtboxComponent) -> void:
	print("freeze effect")
	var parent := hurtbox.get_parent()

	if parent is Enemy:
		parent = parent as Enemy
		parent.freeze()

func poison_effect(_bullet: Node3D, hurtbox: HurtboxComponent) -> void:
	print("poison effect")
	var parent := hurtbox.get_parent()

	if parent is Enemy:
		parent = parent as Enemy
		parent.get_poisoned()
