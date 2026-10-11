extends Node

@export var explosion_scene: PackedScene
@export var explosion_sprite: Texture2D
@export var freeze_sprite: Texture2D
@export var poison_sprite: Texture2D

enum ModifierFlags{
	Explosive = 1 << 0,
	Freezing = 1 << 1
}

var all: Array[ModifierFlags] = [ModifierFlags.Explosive]

var modifiers: Dictionary[ModifierFlags, Callable]
var sprites: Dictionary[ModifierFlags, Texture2D]

func _ready() -> void:
	modifiers[ModifierFlags.Explosive] = explosive_affect
	sprites[ModifierFlags.Explosive] = explosion_sprite

# all effects will need this same function signature
func explosive_affect(bullet: Node3D, hurtbox: HurtboxComponent) -> void:
	print("explosion effect")
	var new_explosion = explosion_scene.instantiate()
	bullet.get_parent().add_child(new_explosion)
	new_explosion.global_position = bullet.global_position
	
