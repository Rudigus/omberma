extends Node
class_name ServerAdvertiser, 'res://Assets/ServerAdvertiser.png'

const DEFAULT_PORT := 3111

# How often to broadcast out to the network that this host is active
export (float) var broadcast_interval: float = 1.0
var serverInfo := {"name": "LAN Game", "port": DEFAULT_PORT}

var socketUDP: PacketPeerUDP
var broadcastTimer := Timer.new()
var broadcastPort := DEFAULT_PORT

func _enter_tree():
	broadcastTimer.wait_time = broadcast_interval
	broadcastTimer.one_shot = false
	broadcastTimer.autostart = true
	
	# Place to put fixed server info
	serverInfo["name"] = gamestate.player_name
	
	if get_tree().is_network_server():
		add_child(broadcastTimer)
		broadcastTimer.connect("timeout", self, "broadcast") 
		
		socketUDP = PacketPeerUDP.new()
		socketUDP.set_broadcast_enabled(true)
		socketUDP.set_dest_address('255.255.255.255', broadcastPort)

func broadcast():
	#print('Broadcasting game...')
	
	# Place to put changing server info
	#print(gamestate.players)
	serverInfo["playersCount"] = "%d/%d" % \
	[gamestate.players.size() + 1, gamestate.MAX_PEERS]
	
	var packetMessage := to_json(serverInfo)
	var packet := packetMessage.to_ascii()
	socketUDP.put_packet(packet)
	print(packet.get_string_from_utf8())

func _exit_tree():
	broadcastTimer.stop()
	if socketUDP != null:
		socketUDP.close()
