extends Node

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id, player_info)
signal player_failed_connected
signal player_disconnected(peer_id)
signal server_disconnected

# https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
var IP_ADDRESS = "127.0.0.1"
var DEFAULT_SERVER_IP = IP_ADDRESS
var PORT = 8888
var MAX_CLIENTS = 4

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

var players_loaded = 0

# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info = {"name": "Name"}

var network_type:String = "None"

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	Console.add_command("ping",cmd_ping)
	Console.add_command("players",cmd_player_names)
	#pass

func _init_server():
	# Create server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.set_multiplayer_peer(peer)
	#multiplayer.multiplayer_peer = peer
	network_type="SERVER"
	players[1] = player_info

func _init_client():
	# Create client.
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.set_multiplayer_peer(peer)
	#multiplayer.multiplayer_peer = peer
	network_type="CLIENT"

func _close_network():
	multiplayer.multiplayer_peer = null

func join_game(address = ""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)
	
func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	
func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	print("peer_id: ", peer_id)
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)
	Global.hide_connection_status()

func _on_connected_fail():
	print("Connect FAIL!")
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	Global.hide_connection_status()
	player_failed_connected.emit()
	
func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	
@rpc("any_peer", "reliable")
func ping():
	print("ping???")
	print("get_unique_id: ", multiplayer.get_unique_id())
	# The server knows who sent the input.
	var sender_id = multiplayer.get_remote_sender_id()
	print("sender_id: ", sender_id)
	print("is server?", multiplayer.is_server())
	pass
	
func cmd_ping():
	ping()

#func get_players():
	#print(players)
	#return

# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_remote", "reliable")
func player_loaded():
	#print("players_loaded: ",players_loaded)
	#print("players.size(): ",players.size())
	if not multiplayer.is_server(): return
	#print("remote player_loaded")
	players_loaded += 1
	#push_error("players_loaded: " + str(players_loaded) + " players.size(): "+ str(players.size()))
	if players_loaded == players.size()-1:#server count remove
		print("player_loaded start game...")
		start_game.rpc()
		players_loaded = 0

@rpc("authority","call_local")
func start_game():
	if not multiplayer.is_server(): return
	#push_error("SERVER START GAME...")
	#var level = Global.game_controller.current_3d_scene.get_node("Level")
	var level = Global.game_controller.current_3d_scene
	if not level:
		print("ERROR NULL NODE3D LEVEL...")
		return 
	#print(" Global.game_controller.current_3d_scene",  Global.game_controller.current_3d_scene)
	#print("level:", level)
	if level.has_method("start_game"):
		# might be here for sync object for client and server peers.
		# wait for loading else player server will not sync.
		await get_tree().create_timer(0.5).timeout # it need to wait for sync else node null for client
		level.start_game.rpc()
	#pass

func cmd_player_names():
	print("peer player >>>")
	for player_idx in multiplayer.get_peers():
		print("peer player id:", player_idx)
	print("player info >>>")
	for player_idx in players:
		print("peer player id:", player_idx)
		if players[player_idx]:
			print("player name:", players[player_idx]["name"])
			#pass
	#pass
