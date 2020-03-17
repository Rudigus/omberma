extends Control

export (NodePath) var serverListPath: NodePath
onready var ServerList := get_node(serverListPath)
onready var MainMenu = load("res://Scenes/main_menu.tscn")
onready var Room = preload("res://Scenes/room.tscn")
onready var Error = $menu/error

# Signals are bad. Remember it. In the end, changing
# a variable in singleton and checking for it is
# the best. Don't judge me.

func _ready():
	if gamestate.errtxt != "":
		Error.dialog_text = gamestate.errtxt
		print(Error.dialog_text)
		Error.popup_centered_minsize()
		gamestate.errtxt = ""

func _on_listener_new_server(serverInfo):
	# Create some UI for the newly found server
	var serverDesc = "%s - %s" % [serverInfo.name, serverInfo.playersCount]
	ServerList.add_item(serverDesc)
	gamestate.servers[ServerList.get_item_count() - 1] = serverInfo

func _on_listener_remove_server(serverIp):
	for serverNode in ServerList.get_children():
		# Just a hacky way to identify the Node and remove it
		if serverNode.text.find(serverIp) > -1:
			ServerList.remove_child(serverNode)
			break

func _on_back_pressed():
	get_tree().change_scene_to(MainMenu)
	
#func _on_game_error(errtxt):
#	Error.dialog_text = errtxt
#	Error.popup_centered_minsize()


func _on_list_item_selected(index):
	gamestate.join_game(gamestate.servers[index].ip, \
	gamestate.player_name)
	get_tree().change_scene_to(Room)
