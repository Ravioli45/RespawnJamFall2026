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

	player.coins -= 5
	
	for i in chosen_slots.size():
		chosen_slots[i] = pick_slot()
	
	animation_player.play("Spin")
	for slot in slots:
		slot.frame = pick_slot()
		slot.play("spin")
	
	slot_timer.start()

	await spin_finished

	var rand := randf()
	# rand = 0.6

	if rand < 0.5:
		var display_indices := range(total_slots)
		display_indices.shuffle()
		display_indices = display_indices.slice(0, 3)
		for i in range(3):
			slots[i].frame = display_indices[i]
	elif rand < 0.9:
		var reward: ModifierTable.ModifierFlags= ModifierTable.all.pick_random()
		# reward = ModifierTable.ModifierFlags.Poison
		match reward:
			ModifierTable.ModifierFlags.Explosive:
				for i in range(slots.size()):
					slots[i].frame = 15
				player.new_modifier(reward)
			ModifierTable.ModifierFlags.Freezing:
				for i in range(slots.size()):
					slots[i].frame = 8
				player.new_modifier(reward)
			
			ModifierTable.ModifierFlags.Poison:
				for i in range(slots.size()):
					slots[i].frame = 16
				player.new_modifier(reward)
	
	else:
		if player.weapon.dice_data.size() >= 4:
			return
		player.new_dice()
		for i in range(slots.size()):
			slots[i].frame = 22


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
