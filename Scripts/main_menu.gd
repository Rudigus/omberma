extends Control

onready var Title = $menu/title
onready var Name = $menu/name/name_edit
onready var Ip = $menu/server/join/ip_edit
onready var ErrorLabel = $menu/error_label
onready var Host = $menu/server/host/host_button
onready var Stop = $menu/server/join/stop_button
onready var Join = $menu/server/join/join_button
onready var Lobby = preload("res://Scenes/lobby.tscn")
onready var Room = preload("res://Scenes/room.tscn")
onready var ModeDropdown = $menu/server/host/mode_dropdown

func _ready():
	# Called every time the node is added to the scene.
	#gamestate.connect("game_error", self, "_on_game_error")
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	#gamestate.connect("game_ended", self, "_on_game_ended")

func _on_host_pressed():

	var player_name = Name.text
	if player_name == "":
		ErrorLabel.text = "Invalid name!"
		return

	gamestate.host_game(player_name)
	if(!get_tree().has_network_peer()):
		ErrorLabel.text = "Couldn't create server!"
		return
	var selectedItemText = \
	ModeDropdown.get_item_text(ModeDropdown.get_selected_id())
	if selectedItemText == "UPnP":
		gamestate.upnp = UPNP.new()
		# If the functions returns a non-zero value (failure)
		if gamestate.upnp.discover() or \
		gamestate.upnp.add_port_mapping(gamestate.DEFAULT_PORT):
			ErrorLabel.text = "UPNP error"
			return
	
	get_tree().change_scene_to(Room)

func _on_join_button_pressed():

	var player_name = Name.text
	if player_name == "":
		ErrorLabel.text = "Invalid name!"
		return

	var ip = Ip.text
	if not ip.is_valid_ip_address():
		ErrorLabel.text = "Invalid IP address!"
		return

	gamestate.join_game(ip, player_name)
	Stop.disabled = false
	Join.disabled = true

func _on_browse_pressed():

	if Name.text == "":
		ErrorLabel.text = "Invalid name!"
		return

	gamestate.player_name = Name.text
	get_tree().change_scene_to(Lobby)

func _on_connection_success():
	get_tree().change_scene_to(Room)

func _on_connection_failed():
	ErrorLabel.set_text("Connection failed.")
	get_tree().set_network_peer(null) # Remove peer
	Stop.disabled = true
	Join.disabled = false

#func _on_game_ended():
#	get_tree().change_scene_to(Lobby)

func _on_stop_button_pressed():
	get_tree().emit_signal("connection_failed")
