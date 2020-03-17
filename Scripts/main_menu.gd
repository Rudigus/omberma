extends Control

onready var Title = $menu/title
onready var Name = $menu/host/name_edit
onready var ErrorLabel = $menu/error_label
onready var Host = $menu/host/host_button
onready var Lobby = preload("res://Scenes/lobby.tscn")
onready var Room = preload("res://Scenes/room.tscn")

#func _ready():
	# Called every time the node is added to the scene.
	#gamestate.connect("game_error", self, "_on_game_error")
	#gamestate.connect("connection_failed", self, "_on_connection_failed")
	#gamestate.connect("connection_succeeded", self, "_on_connection_success")
	#gamestate.connect("game_ended", self, "_on_game_ended")

func _on_host_pressed():
	if Name.text == "":
		ErrorLabel.text = "Invalid name!"
		return
	#if server_running():
	# Server can be already running on the same machine
	#	ErrorLabel.text = "Couldn't create server."
	#	return
	
	var player_name = Name.text
	gamestate.host_game(player_name)
	if(!get_tree().has_network_peer()):
		ErrorLabel.text = "Couldn't create server"
		return
	get_tree().change_scene_to(Room)
	
func _on_browse_pressed():
	if Name.text == "":
		ErrorLabel.text = "Invalid name!"
		return
		
	gamestate.player_name = Name.text
	get_tree().change_scene_to(Lobby)

#func _on_connection_success():
#	get_tree().change_scene_to(Room)

#func _on_connection_failed():
#	ErrorLabel.set_text("Connection failed.")

#func _on_game_ended():
#	get_tree().change_scene_to(Lobby)

#func _on_stop_pressed():
#	get_tree().emit_signal("connection_failed")
