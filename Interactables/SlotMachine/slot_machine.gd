class_name SlotMachine
extends StaticBody3D

signal spin_finished

@export var slots: Array[AnimatedSprite3D] = []
var total_slots: int = 24
var chosen_slots: Array[int] = [0,0,0]

@export var animation_player: AnimationPlayer
@export var pull_sound: AudioStreamPlayer3D
@export var spin_sound: AudioStreamPlayer3D
@export var win_sound: AudioStreamPlayer3D
var player: Player

var can_spin := true

func _ready() -> void:
	for slot in slots:
		slot.frame = pick_slot()

func interact(the_player: Player) -> void:
	if not can_spin:
		return
	can_spin = false

	player = the_player
	player.coins -= 5
	
	for i in chosen_slots.size():
		chosen_slots[i] = pick_slot()
	
	animation_player.play("Spin")
	pull_sound.play()

func _on_sound_finished() -> void:
	for slot in slots:
			slot.frame = pick_slot()
			slot.play("spin")
	spin_sound.play()
	
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
		win_sound.play()
		var reward: ModifierTable.ModifierFlags= ModifierTable.all.pick_random()
		#reward = ModifierTable.ModifierFlags.Explosive
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
		win_sound.play()
		if player.weapon.dice_data.size() >= 4:
			player.coins += 5
			return
		player.new_dice()
		for i in range(slots.size()):
			slots[i].frame = 22

func _on_animation_finished(anim_name: StringName) -> void:
	pass
		
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
