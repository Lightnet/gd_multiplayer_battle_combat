extends Control

const UI_MESSAGE = preload("res://scenes/ui/ui_message.tscn")
@onready var ui_messages: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var scroll_container: ScrollContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer

func _ready() -> void:
	clear_message()
	pass 

func clear_message():
	for message in ui_messages.get_children():
		message.queue_free()
	#pass

func _on_line_edit_text_submitted(new_text: String) -> void:
	print("message: ", new_text)
	sent_message.rpc(new_text)
	pass

@rpc("any_peer","call_local")
func sent_message(msg:String)->void:
	var peer_id = multiplayer.get_remote_sender_id()
	var message = UI_MESSAGE.instantiate()
	var player_name:String = "None"
	ui_messages.add_child(message)
	for idx in GameNetwork.players:
		if idx == peer_id:
			player_name = GameNetwork.players[idx]["name"]
	message.set_user_message(player_name,msg)
	# Scroll to the bottom after adding the new message
	await get_tree().create_timer(0.01).timeout  # Small delay to ensure UI is updated
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value as int
	pass
