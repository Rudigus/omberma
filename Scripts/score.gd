extends HBoxContainer

var player_labels = {}

func _process(_delta):
	var players_left = get_node("../players").get_child_count()
	players_left = 0 # Condition to test the game with only 1 client
	if players_left == 1:
		var winner_name = \
		get_node("../players").get_child(0).get_node("label").get_text()

		get_node("../winner").set_text("THE WINNER IS:\n" + winner_name)
		get_node("../winner").show()

sync func increase_score(for_who):
	assert(for_who in player_labels)
	var pl = player_labels[for_who]
	pl.score += 1
	pl.label.set_text(pl.name + "\n" + str(pl.score))

func add_player(id, new_player_name):
	var l = Label.new()
	l.set_align(Label.ALIGN_CENTER)
	l.set_text(new_player_name + "\n" + "0")
	l.set_h_size_flags(SIZE_EXPAND_FILL)
	var font = DynamicFont.new()
	font.set_size(18)
	font.set_font_data(preload("res://Resources/montserrat.otf"))
	l.add_font_override("font", font)
	add_child(l)

	player_labels[id] = { name = new_player_name, label = l, score = 0 }

func _ready():
	get_node("../winner").hide()
	set_process(true)

func _on_exit_game_pressed():
	gamestate.end_game()
