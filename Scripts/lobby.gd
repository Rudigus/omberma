extends Control

export (NodePath) var serverListPath: NodePath
onready var ServerList := get_node(serverListPath)
onready var MainMenu = load("res://Scenes/main_menu.tscn")
onready var Room = preload("res://Scenes/room.tscn")

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

func _on_list_item_activated(index):
	gamestate.join_game(gamestate.servers[index].ip, \
	gamestate.player_name)
	get_tree().change_scene_to(Room)
