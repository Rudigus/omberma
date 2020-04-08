extends MarginContainer

onready var TrackSelector = $track_selector

func _on_back_pressed():
	get_tree().change_scene_to(gamestate.MainMenu)


func _on_select_track_pressed():
	TrackSelector.popup_centered()


func _on_track_selector_file_selected(path):
	var stream = load(path)
	if stream is AudioStream:
		Audio.stop()
		Audio.stream = stream
		Audio.play()
	else:
		print("Invalid file format. Only WAV and OGG are supported.")
