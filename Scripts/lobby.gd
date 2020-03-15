extends Control

onready var Connect = $connect
onready var Players = $players
onready var Name = $connect/name
onready var ErrorLabel = $connect/error_label
onready var Host = $connect/host
onready var Error = $error
onready var PlayerList = $players/list
onready var PlayersStart = $players/start
onready var Title = $title
onready var Advertiser = $players/advertiser
onready var Servers = $servers

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

	Connect.hide()
	Players.show()
	Title.hide()
	ErrorLabel.text = ""

	var player_name = Name.text
	gamestate.host_game(player_name)
	refresh_lobby()
	Advertiser.initialize()
	
func _on_browse_pressed():
	if Name.text == "":
		ErrorLabel.text = "Invalid name!"
		return
		
	Connect.hide()
	Servers.show()
	Title.hide()
	ErrorLabel.text=""

	#var player_name = Name.text
	#gamestate.join_game(ip, player_name)
	# refresh_lobby() gets called by the player_list_changed signal

func _on_connection_success():
	Connect.hide()
	Players.show()
	Title.hide()

func _on_connection_failed():
	#Host.disabled = false
	#Join.disabled = false
	#Stop.disabled = true;
	ErrorLabel.set_text("Connection failed.")

func _on_game_ended():
	show()
	Connect.show()
	Players.hide()
	Host.disabled = false

func _on_game_error(errtxt):
	Error.dialog_text = errtxt
	Error.popup_centered_minsize()

func refresh_lobby():
	var players = gamestate.get_player_list()
	players.sort()
	PlayerList.clear()
	PlayerList.add_item(gamestate.get_player_name() + " (You)")
	for p in players:
		PlayerList.add_item(p)

	PlayersStart.disabled = not get_tree().is_network_server()

func _on_start_pressed():
	gamestate.begin_game()

func _on_leave_pressed():
	Connect.show()
	Players.hide()
	Title.show()
	Advertiser.shutdown()

func _on_stop_pressed():
	get_tree().emit_signal("connection_failed")

func _on_back_pressed():
	Servers.hide()
	Connect.show()
	Title.show()
