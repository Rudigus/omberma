extends Control

onready var Connect = $connect
onready var Name = $connect/name
onready var ErrorLabel = $connect/error_label
onready var Host = $connect/host
onready var Error = $error
onready var Title = $title
onready var Lobby = preload("res://Scenes/lobby.tscn")
onready var Room = preload("res://Scenes/room.tscn")

func _ready():
	# Called every time the node is added to the scene.
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")

func _on_host_pressed():
	if Name.text == "":
		ErrorLabel.text = "Invalid name!"
		return

	ErrorLabel.text = ""
	get_tree().change_scene_to(Room)
	var player_name = Name.text
	gamestate.host_game(player_name)
	#refresh_lobby()
	
func _on_browse_pressed():
	if Name.text == "":
		ErrorLabel.text = "Invalid name!"
		return
		
	ErrorLabel.text=""
	get_tree().change_scene_to(Lobby)

	#var player_name = Name.text
	#gamestate.join_game(ip, player_name)
	# refresh_lobby() gets called by the player_list_changed signal

func _on_connection_success():
	get_tree().change_scene_to(Room)

func _on_connection_failed():
	#Host.disabled = false
	#Join.disabled = false
	#Stop.disabled = true;
	ErrorLabel.set_text("Connection failed.")

func _on_game_ended():
	show()
	get_tree().change_scene_to(Lobby)
	Host.disabled = false

func _on_game_error(errtxt):
	Error.dialog_text = errtxt
	Error.popup_centered_minsize()

func _on_stop_pressed():
	get_tree().emit_signal("connection_failed")
