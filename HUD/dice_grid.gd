class_name DiceGrid
extends Control

@export var die_scene: PackedScene
@export var dice_container: Container
@export var display_dice: Array[DisplayDie]

var rolling: bool = false

func roll_all():
	rolling = true
	for d in display_dice:
		d.roll_animation()
		
func show_faces(data: Array[FaceData]):
	rolling = false
	for i in min(display_dice.size(), data.size()):
		#print(i, data[i])
		display_dice[i].show_face(data[i])
		#break

func add_dice(data: FaceData):
	var new_die = die_scene.instantiate() as DisplayDie
	dice_container.add_child(new_die)
	display_dice.append(new_die)
	if !rolling:
		new_die.show_face(data)
