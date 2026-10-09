extends Node

@export var explosion_scene: PackedScene

enum ModifierFlags{
	Explosive = 1 << 0,
	Freezing = 1 << 1
}

var all: Array[ModifierFlags] = [ModifierFlags.Explosive]

var modifiers: Dictionary[ModifierFlags, Callable]

func _ready() -> void:
	modifiers[ModifierFlags.Explosive] = explosive_affect

# all effects will need this same function signature
func explosive_affect(bullet: Node3D, hurtbox: HurtboxComponent) -> void:
	print("explosion effect")
	
