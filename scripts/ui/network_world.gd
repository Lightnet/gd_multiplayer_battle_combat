extends Node3D

const DUMMY_PLAYER = preload("res://prefabs/player/dummy_player.tscn")
@onready var spawn_point: Node3D = $SpawnPoint
@onready var label_network_type: Label = $CanvasLayer/Control/Label_NetworkType
@onready var label_player_name: Label = $CanvasLayer/Control/Label_PlayerName

func _enter_tree() -> void:
	#GameNetwork.player_connected.connect(event_add_player)
	Console.add_command("spawnplayers", cmd_spawn_players)
	GameNetwork.player_disconnected.connect(_on_disconnect_peer)
	pass

func _exit_tree() -> void:
	#GameNetwork.player_connected.disconnect(event_add_player)
	Console.remove_command("spawnplayers")
	pass

func _ready() -> void:
	#print("id: ",multiplayer.get_unique_id())
	#print("is_server: ",multiplayer.is_server())
	GameNetwork.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.
	label_network_type.text = GameNetwork.network_type
	setup_player_name()
	#pass

func setup_player_name():
	label_player_name.text = GameNetwork.player_info["name"]
	pass

# Called only on the server.
#@rpc("any_peer", "reliable")
@rpc("call_local")
func start_game():
	#this is debug to know what debugger logs is the server or client output.
	var network_node:Node3D = Node3D.new()
	if multiplayer.is_server():
		network_node.name = "SERVER"
		add_player.rpc()
		#add_player()
		for player_idx in multiplayer.get_peers():
			#push_error(network_node.name, " Player ID:", player_idx)
			add_player.rpc(player_idx)
	else:
		network_node.name = "CLIENT"
		#add_player()
	#print_debug(network_node.name)
	#printerr(network_node.name)
	push_error(network_node.name)
	#add_child(network_node)
	call_deferred("add_child", network_node)
	# All peers are ready to receive RPCs in this scene.
	print("server call to start game...")
	pass

#@rpc("any_peer","call_local")
#@rpc("any_peer", "call_local", "reliable")
@rpc("call_local")
func add_player(peer_id = 1):
	
	if has_node(str(peer_id)):
		return
	
	#print("player spawn peer_id:", peer_id)
	var player = DUMMY_PLAYER.instantiate()
	player.name = str(peer_id)
	#player.id = str(peer_id)
	await get_tree().create_timer(0.1).timeout # it need to wait for sync else node null for client
	#call_deferred("add_child", player) #error node null
	Global.game_controller.current_3d_scene.call_deferred("add_child", player) #fixed path to handle sync
	#broadcast player is set position
	set_player_position.rpc(peer_id, spawn_point.global_position)
	pass

# set player id for spawn position
@rpc("any_peer","call_local")
func set_player_position(peer_id:int, pos:Vector3):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.set_global_position(pos)
	pass

#func _process(delta: float) -> void:
	#pass

func cmd_spawn_players():
	start_game.rpc()
	pass

func _on_disconnect_peer(peer_id):
	del_player(peer_id)
	pass
	
func del_player(id):
	rpc("_del_player",id)
	
@rpc("any_peer","call_local")
func _del_player(id):
	var player  = get_node_or_null(str(id))
	print("del player", player)
	if player:
		player.queue_free()
