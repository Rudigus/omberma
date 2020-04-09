extends KinematicBody2D

const MOTION_SPEED = 90.0

puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

export var stunned = false

var player_lives = gamestate.settings["Player Lives"]
var bomb_capacity = gamestate.settings["Bomb Capacity"]
var available_bombs = bomb_capacity

# Use sync because it will be called everywhere
sync func setup_bomb(bomb_name, pos, by_who):
	var bomb = preload("res://Scenes/bomb.tscn").instance()
	bomb.set_name(bomb_name) # Ensure unique name for the bomb
	bomb.position = pos
	bomb.from_player = by_who
	bomb.Bomber = $"."
	# No need to set network master to bomb, will be owned by server by default
	get_node("../..").add_child(bomb)

var current_anim = ""
var prev_bombing = false
var bomb_index = 0

func _physics_process(_delta):
	var motion = Vector2()

	if is_network_master():
		if Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("move_right"):
			motion += Vector2(1, 0)
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("move_down"):
			motion += Vector2(0, 1)

		var bombing = Input.is_action_pressed("set_bomb")

		if stunned:
			bombing = false
			motion = Vector2()

		if bombing and not prev_bombing and available_bombs > 0:
			var bomb_name = get_name() + str(bomb_index)
			var bomb_pos = position
			available_bombs -= 1
			rpc("setup_bomb", bomb_name, bomb_pos, get_tree().get_network_unique_id())

		prev_bombing = bombing

		rset("puppet_motion", motion)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		motion = puppet_motion

	var new_anim = "standing"
	if motion.y < 0:
		new_anim = "walk_up"
	elif motion.y > 0:
		new_anim = "walk_down"
	elif motion.x < 0:
		$sprite.flip_h = true
		new_anim = "walk_right"
	elif motion.x > 0:
		$sprite.flip_h = false
		new_anim = "walk_right"

	if stunned:
		new_anim = "stunned"

	if new_anim == "standing":
		current_anim = new_anim
		$anim.stop()

	if new_anim != current_anim:
		current_anim = new_anim
		get_node("anim").play(current_anim)

	# FIXME: Use move_and_slide
	move_and_slide(motion * MOTION_SPEED)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

puppet func stun():
	stunned = true

master func exploded(_by_who):
	if stunned:
		return
	rpc("decrease_player_lives")
	rpc("stun") # Stun puppets
	stun() # Stun master - could use sync to do both at once

func set_player_name(new_name):
	get_node("label").set_text(new_name)
	
remotesync func decrease_player_lives():
	player_lives -= 1
	print(player_lives)
	if player_lives <= 0:
		queue_free()

remotesync func recharge_bombs():
	available_bombs += 1

func _ready():
	stunned = false
	puppet_pos = position
