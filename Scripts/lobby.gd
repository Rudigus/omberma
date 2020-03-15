extends Control

export (NodePath) var serverListPath: NodePath
onready var ServerList := get_node(serverListPath)
onready var MainMenu = load("res://Scenes/main_menu.tscn")

func _on_listener_new_server(serverInfo):
	# Create some UI for the newly found server
	var serverNode := Label.new()
	serverNode.text = "%s - %s" % [serverInfo.ip, serverInfo.name]
	ServerList.add_child(serverNode)

func _on_listener_remove_server(serverIp):
	for serverNode in ServerList.get_children():
		# Just a hacky way to identify the Node and remove it
		if serverNode.text.find(serverIp) > -1:
			ServerList.remove_child(serverNode)
			break

func _on_back_pressed():
	get_tree().change_scene_to(MainMenu)
