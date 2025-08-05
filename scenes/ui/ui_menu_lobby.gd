extends Control

# https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html 

const UI_USER_MESSAGE = preload("res://scenes/ui/ui_user_message.tscn")
const UI_LOBBY_PLAYER = preload("res://scenes/ui/ui_lobby_player.tscn")
@onready var scroll_container: ScrollContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer
@onready var vbc_messages: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/VBC_Messages
@onready var label_player_name: Label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Label_PlayerName
@onready var label_network_type: Label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Label_NetworkType
@onready var btn_start: Button = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/btn_start
@onready var ui_server_dc_accept_dialog: AcceptDialog = $UIServerDisconnnect/UIServerDCAcceptDialog


@onready var v_box_container_players: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/PanelContainer/ScrollContainer/VBoxContainer_Players

@export var world_3d_scene:String
@export var gui_scene:String

func _ready() -> void:
	label_player_name.text = GameNetwork.player_info.name
	label_network_type.text = GameNetwork.network_type
	
	if GameNetwork.network_type == "SERVER":
		btn_start.disabled = false
	else:
		btn_start.disabled = true
	clear_messages()
	clear_lobby_players()
	GameNetwork.player_connected.connect(_on_connect_player)
	GameNetwork.server_disconnected.connect(_on_disconnect)
	#pass

func _on_connect_player(_peer_id, player_info):
	var lobby_player = UI_LOBBY_PLAYER.instantiate()
	
	v_box_container_players.add_child(lobby_player)
	print("name: ", player_info["name"])
	lobby_player.set_player_name(player_info["name"])
	pass

func _exit_tree() -> void:
	GameNetwork.player_connected.disconnect(_on_connect_player)
	pass

func _on_disconnect()->void:
	print("server disconnected")
	ui_server_dc_accept_dialog.show()
	pass

func clear_lobby_players()->void:
	for node_player in v_box_container_players.get_children():
		node_player.queue_free()
	pass

func clear_messages() -> void:
	for node_msg in vbc_messages.get_children():
		node_msg.queue_free()
	pass

func _on_line_edit_chat_message_gui_input(_event: InputEvent) -> void:
	#if event
	print("test")
	pass

func _on_line_edit_chat_message_text_submitted(new_text: String) -> void:
	print("message >> ", new_text)
	add_message(new_text) #local
	add_message.rpc(new_text) #to boardcast
	pass

@rpc("any_peer", "reliable")
func add_message(_message:String)->void:
	var sender_id = multiplayer.get_remote_sender_id()
	var username = "Unknown"
	print("sender_id:", sender_id)
	if sender_id == 0: #if local
		username = GameNetwork.player_info.name
	else: #server or client that match id player list
		print("sender_id: ",sender_id)
		print("GameNetwork.players: ", GameNetwork.players)
		for playername in GameNetwork.players:
			if sender_id == playername:
				username = GameNetwork.players[playername]["name"]
				break
	var message = UI_USER_MESSAGE.instantiate()
	vbc_messages.add_child(message)
	message.set_name_message(username,_message)
	_scroll_to_bottom()
	#pass

func _scroll_to_bottom():
	# Wait for the next frame to ensure the content is updated
	await get_tree().process_frame
	# Set scroll_vertical to the maximum value
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value as int

func _on_btn_start_pressed() -> void:
	#print("is_server:", multiplayer.is_server())
	if multiplayer.is_server():
		if not world_3d_scene.is_empty():
			#local
			#Global.game_controller.change_3d_scene(world_3d_scene)
			#Global.game_controller.change_gui_scene(gui_scene)
			#peer
			Global.game_controller.change_3d_scene.rpc(world_3d_scene)
			Global.game_controller.change_gui_scene.rpc(gui_scene)
	pass

# for list players
func add_player():
	pass

func _on_accept_dialog_confirmed() -> void:
	print("close?")
	multiplayer.multiplayer_peer = null
	Global.game_controller.change_gui_scene("res://scenes/ui/ui_menu_multiplayer.tscn")
	
	pass
