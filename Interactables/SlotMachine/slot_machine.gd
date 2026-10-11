class_name SlotMachine
extends StaticBody3D

signal spin_finished

@export var slots: Array[AnimatedSprite3D] = []
var total_slots: int = 24
var chosen_slots: Array[int] = [0,0,0]
@export var slot_timer: Timer

@export var animation_player: AnimationPlayer

var can_spin := true

func _ready() -> void:
	for slot in slots:
		slot.frame = pick_slot()

func interact(player: Player) -> void:
	if not can_spin:
		return
	can_spin = false
	
	for i in chosen_slots.size():
		chosen_slots[i] = pick_slot()
	
	animation_player.play("Spin")
	for slot in slots:
		slot.play("spin")
	
	slot_timer.start()

	await spin_finished
	player.new_dice()
	


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Spin":
		pass
		# can_spin = true
		
func pick_slot() -> int:
	return (randi() % total_slots)

func on_slot_timer_finished() -> void:
	can_spin = true
	for i in slots.size():
		slots[i].stop()
		slots[i].frame = chosen_slots[i]

	spin_finished.emit()
	
	if chosen_slots[0] == chosen_slots[1] and chosen_slots[1] == chosen_slots[2]:
		print("You win!")
