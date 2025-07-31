extends Control

# https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html 

const UI_USER_MESSAGE = preload("res://scenes/ui/ui_user_message.tscn")

@onready var scroll_container: ScrollContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer
@onready var vbc_messages: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/VBC_Messages
@onready var label_player_name: Label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Label_PlayerName
@onready var label_network_type: Label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Label_NetworkType
@onready var btn_start: Button = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/btn_start

@export var world_3d_scene:String
@export var gui_scene:String

func _ready() -> void:
	label_player_name.text = GameNetwork.player_info.name
	label_network_type.text = GameNetwork.network_type
	
	if GameNetwork.network_type == "SERVER":
		btn_start.disabled = false
	else:
		btn_start.disabled = true
	#pass

#func _process(delta: float) -> void:
	#pass

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
