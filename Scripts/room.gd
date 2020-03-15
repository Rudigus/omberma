extends Panel

onready var PlayerList = $list
onready var GameStart = $start
onready var MainMenu = load("res://Scenes/main_menu.tscn")

func refresh_lobby():
	var players = gamestate.get_player_list()
	players.sort()
	PlayerList.clear()
	PlayerList.add_item(gamestate.get_player_name() + " (You)")
	for p in players:
		PlayerList.add_item(p)

	GameStart.disabled = not get_tree().is_network_server()
	
func _on_leave_pressed():
	get_tree().emit_signal("server_disconnected")
	get_tree().change_scene_to(MainMenu)

func _on_start_pressed():
	gamestate.begin_game()
