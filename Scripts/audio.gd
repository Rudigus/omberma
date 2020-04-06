extends AudioStreamPlayer

var initial_stream = load("res://Audio/Rolemusic_-_the_river.ogg")

func _ready():
	Audio.stream = initial_stream
	Audio.bus = "Master"
	Audio.play()
