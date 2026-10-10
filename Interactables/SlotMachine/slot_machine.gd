class_name SlotMachine
extends StaticBody3D

@export var animation_player: AnimationPlayer

var can_spin := true

func interact():
	animation_player.play("Spin")
	can_spin = false


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Spin":
		can_spin = true
