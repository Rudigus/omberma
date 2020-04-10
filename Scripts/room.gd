extends Control

onready var PlayerList = $menu/main_area/lists/players
onready var SettingsList = $menu/main_area/lists/settings
onready var StatusList = $menu/main_area/lists/status
onready var GameStart = $menu/buttons/start
onready var TabList = $menu/main_area/lists
onready var Modifiers = $menu/main_area/modifiers
onready var Increase = $menu/main_area/modifiers/increase
onready var Decrease = $menu/main_area/modifiers/decrease

export(Dictionary) var defaultSettings = {}
# The lowest value a power-up can go
const MIN_POWERUP_VALUE = 1

signal settings_changed(changed_items)

func _ready():
	
	# gamestate variables' initial assignment

	gamestate.status["Room Owner"] = "Coming Soon..." 
	gamestate.settings = defaultSettings
	
	# Signal connections
	connect("settings_changed", gamestate, "_on_settings_changed")
	gamestate.connect("settings_list_changed", self, "refresh_settings")
	gamestate.connect("player_list_changed", self, "refresh_room")
	#gamestate.connect("settings_list_changed", self, "refresh_settings")
	
	# Refreshes
	refresh_room()
	refresh_settings()
	refresh_status()

func refresh_room():
	var players = gamestate.get_player_list()
	players.sort()
	PlayerList.clear()
	PlayerList.add_item(gamestate.get_player_name() + " (You)")
	for p in players:
		PlayerList.add_item(p)

	GameStart.disabled = not get_tree().is_network_server()

func refresh_settings():
	var settings = gamestate.settings
	SettingsList.clear()
	for s in settings.keys():
		SettingsList.add_item(s + ": %d" % settings[s])
		SettingsList.set_item_metadata(SettingsList.get_item_count() - 1, s)
	
	Increase.disabled = not get_tree().is_network_server()
	Decrease.disabled = Increase.disabled
	
func refresh_status():
	var status = gamestate.status
	StatusList.clear()
	for s in status.keys():
		StatusList.add_item(s + ": %s" % status[s])

func _on_leave_pressed():
	gamestate.players.clear()
	var isServer = get_tree().is_network_server()
	get_tree().set_network_peer(null)
	if gamestate.upnp != null:
		print(gamestate.upnp.delete_port_mapping(gamestate.DEFAULT_PORT))
	if isServer:
		get_tree().change_scene_to(gamestate.MainMenu)
	else:
		get_tree().change_scene_to(gamestate.Lobby)

func _on_start_pressed():
	gamestate.begin_game()

func _on_lists_tab_changed(tab):
	if TabList.get_tab_title(tab) == "settings":
		Modifiers.show()
	else:
		Modifiers.hide()

# Triggered when the increase or the decrease button are pressed.
func _on_modifier_button_pressed(modifierValue):
	var selectedItems = SettingsList.get_selected_items()
	var changedItems = {}
	for item in selectedItems:
		var s = SettingsList.get_item_metadata(item)
		if gamestate.settings[s] + modifierValue >= MIN_POWERUP_VALUE:
			gamestate.settings[s] += modifierValue
			changedItems[s] = gamestate.settings[s]
			SettingsList.set_item_text(item, s + ": %d" % gamestate.settings[s])
	if changedItems.size() > 0:
		emit_signal("settings_changed", changedItems)


func _on_status_item_selected(index):
	OS.set_clipboard(StatusList.get_item_text(index))
