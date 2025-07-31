extends Node3D

const DUMMY_PLAYER = preload("res://prefabs/player/dummy_player.tscn")

@onready var label_player_name: Label = $CanvasLayer/Control/Label_PlayerName
@onready var label_network_type: Label = $CanvasLayer/Control/Label_NetworkType
@onready var h_box_container: HBoxContainer = $CanvasLayer/Control/HBoxContainer
@onready var h_box_container_2: HBoxContainer = $CanvasLayer/Control/HBoxContainer2
@onready var spawn_point: Node3D = $SpawnPoint

func _ready() -> void:
	h_box_container_2.hide()
	GameNetwork.player_connected.connect(player_connect)
	pass

func _on_btn_host_pressed() -> void:
	GameNetwork.network_type = "SERVER"
	label_network_type.text = "SERVER"
	GameNetwork.player_info["name"] = rand_str()
	label_player_name.text = GameNetwork.player_info["name"]
	GameNetwork._init_server()
	h_box_container.hide()
	h_box_container_2.show()
	pass

func _on_btn_join_pressed() -> void:
	GameNetwork.network_type = "CLIENT"
	label_network_type.text = "CLIENT"
	GameNetwork.player_info["name"] = rand_str()
	label_player_name.text = GameNetwork.player_info["name"]
	GameNetwork._init_client()
	h_box_container.hide()
	h_box_container_2.show()
	pass

func _on_btn_start_pressed() -> void:
	if multiplayer.is_server():
		h_box_container_2.hide()
		
		close_containter.rpc()
		start_game()
		#start_game.rpc()
	#pass
@rpc("any_peer", "call_remote", "reliable")
func close_containter():
	h_box_container_2.hide()
	pass

#@rpc("authority","call_remote","reliable") #work for auth server
func start_game():
	# All peers are ready to receive RPCs in this scene.
	print("server call to start game...")
	if multiplayer.is_server():
		add_player()
		for peer in multiplayer.get_peers():
			add_player(peer)
			#pass
			
#@rpc("any_peer", "call_local", "reliable")
func add_player(peer_id:int = 1)->void:
	
	if has_node(str(1)):
		print("found id 1")
	if has_node(str(peer_id)):
		print("A player with ID", peer_id, "already exists.")
		return
	
	var player = DUMMY_PLAYER.instantiate()
	
	player.name = str(peer_id)  #need to assign to match sync
	#get_tree().current_scene.add_child(player,true)
	player.set_multiplayer_authority(peer_id)
	#get_tree().current_scene.add_child(player,true)
	get_tree().current_scene.call_deferred("add_child", player)
	#player.name = str(peer_id)# nope id before
	await get_tree().create_timer(0.1).timeout  #need to wait to sync else error !get_tree()
	#player.global_position = spawn_point.global_position
	#player.position = spawn_point.global_position # does not work	
	set_player_position.rpc(peer_id, spawn_point.global_position) #boardcast to update player id position
	#pass

# set player id position
@rpc("call_local")
func set_player_position(pid:int,pos:Vector3):
	var player = get_node(str(pid)) #current scene
	player.set_global_position(pos)
	#pass

#@rpc("authority", "call_local", "reliable") #nope work on client not server
@rpc("authority", "call_remote", "reliable") #
func auth_add_player(peer_id:int = 1)->void:
	#if not multiplayer.is_server():
		#return
	if has_node(str(1)):
		print("found id 1")
	if has_node(str(peer_id)):
		print("A player with ID", peer_id, "already exists.")
		return
	await get_tree().create_timer(0.5).timeout
	var player = DUMMY_PLAYER.instantiate()
	player.name = str(peer_id)
	player.set_multiplayer_authority(peer_id)
	get_tree().current_scene.add_child(player,true)
	player.global_position = spawn_point.global_position
	#pass

func rand_str()->String:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var letters = "abcdefghijklmnopqrstuvwxyz"
	var random_string = ""
	for i in range(4):
		random_string += letters[rng.randi_range(0, letters.length() - 1)]
	print(random_string)
	return random_string

# ===============================================
func player_connect(pid:int,playerinfo)->void:
	print("player connected...", playerinfo)
	#add_player(pid) # works
	pass

func _on_multiplayer_spawner_spawned(node: Node) -> void:
	print("get_unique_id: ",multiplayer.get_unique_id())
	print("name spawn: ",node.name)
	pass
