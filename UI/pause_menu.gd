extends ColorRect

func quit() -> void:
	if get_tree().get_current_scene().get_name() == "MainMenu":
		get_tree().quit()
	get_tree().change_scene_to_file('uid://dvrdrja6fxinq')
	
func reveal() -> void:
	if visible:
		hide()
	else:
		show()
