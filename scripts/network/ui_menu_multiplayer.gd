extends Control

@onready var line_edit_player_name: LineEdit = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/LineEdit_PlayerName
@onready var line_edit_address: LineEdit = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LineEdit_Address
@onready var line_edit_port: LineEdit = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LineEdit_Port

@export var ui_scene:String

func _ready() -> void:
	line_edit_player_name.text = rand_str()
	pass
	
#func _process(delta: float) -> void:
	#pass

func _on_btn_host_pressed() -> void:
	if not ui_scene.is_empty():
		var address = line_edit_address.text
		var port = line_edit_port.text
		#print("Address:", address)
		#print("Port:", port)
		GameNetwork.IP_ADDRESS = address
		GameNetwork.PORT = port.to_int()
		GameNetwork.player_info["name"] = line_edit_player_name.text
		GameNetwork._init_server()
		Global.game_controller.change_gui_scene(ui_scene)
	#pass
	
func _on_btn_join_pressed() -> void:
	if not ui_scene.is_empty():
		var address = line_edit_address.text
		var port = line_edit_port.text
		#print("Address:", address)
		#print("Port:", port)
		GameNetwork.IP_ADDRESS = address
		GameNetwork.PORT = port.to_int()
		
		GameNetwork.player_info["name"] = line_edit_player_name.text
		GameNetwork._init_client()
		Global.game_controller.change_gui_scene(ui_scene)
		Global.show_connection_status()
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
